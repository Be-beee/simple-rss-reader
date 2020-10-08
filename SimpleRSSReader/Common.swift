//
//  Common.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

//typealias URLInfo = (title: String, url: String)
class URLInfo: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var title: String = ""
    var url: String = ""
    
    override init() {}
    
    init(title: String, url: String) {
        self.title = title
        self.url = url
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: "title")
        coder.encode(url, forKey: "url")
    }
    
    required convenience init?(coder: NSCoder) {
        let title = coder.decodeObject(forKey: "title") as! String
        let url = coder.decodeObject(forKey: "url") as! String
        self.init(title: title, url: url)
    }
}

// MARK: - Delegate
protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: Int?)
}


// MARK: - Setting Menu, Archive
var subscribeMenu: [URLInfo] = []

func saveData(data: Any, at: String) {
    DispatchQueue.global().async {
        let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        guard let archivedURL = documentDirectory?.appendingPathComponent(at) else {
            return
        }
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            try archivedData.write(to: archivedURL)
        } catch {
            print(error)
        }
    }
}

func loadData(at: String) -> Any? {
    let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
    
    guard let archiveURL = documentDirectory?.appendingPathComponent(at) else {
        return nil
    }
    
    guard let codedData = try? Data(contentsOf: archiveURL) else {
        return nil
    }
    
    guard let unarchivedData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) else {
        return nil
    }
    return unarchivedData
}




// MARK: - Setting RSS Information

enum Tag {
    case chTitle
    case chLastBuildDate
    case itemTitle
    case itemLink
    case itemPubDate
    case itemDescription
    case none
}

class RSSModel {
    var title: String
    var lastBuildDate: String
    var articles: [ItemModel]
    
    init() {
        title = ""
        lastBuildDate = ""
        articles = []
    }
    
    init(title: String, lastBuildDate: String, articles: [ItemModel]) {
        self.title = title
        self.lastBuildDate = lastBuildDate
        self.articles = articles
    }
}

class ItemModel {
    var title: String
    var link: String
    var pubDate: String
    var description: String
    var image: UIImage?
    
    init() {
        title = ""
        link = ""
        pubDate = ""
        description = ""
        image = UIImage(named: "No_Img.png") ?? UIImage()
    }
    
    init(title: String, link: String, pubDate: String, description: String, image: UIImage) {
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.description = description
        self.image = image
    }
}

class RSSParser: NSObject, XMLParserDelegate {
    var url: String = ""
    var isValid: Bool = true
    
    var results = RSSModel()
    var current = ItemModel()
    var isTagInItem: Bool = false
    var tag: Tag = .none
    
    override init() {
        super.init()
    }
    
    init(url: String) {
        super.init()
        self.url = url
        guard let hasUrl = URLComponents(string: self.url)?.url else {
            isValid = false
            return
        }
        guard let parser = XMLParser(contentsOf: hasUrl) else {
            return
        }
        
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item" {
            current = ItemModel()
            isTagInItem = true
        } else if elementName == "title" {
            switch isTagInItem {
            case true:
                tag = .itemTitle
            case false:
                tag = .chTitle
            }
        } else if elementName == "link" {
            switch isTagInItem {
            case true:
                tag = .itemLink
            default:
                break
            }
        } else if elementName == "description" {
            switch isTagInItem {
            case true:
                tag = .itemDescription
            default:
                break
            }
        } else if elementName == "lastBuildDate" {
            tag = .chLastBuildDate
        } else if elementName == "pubDate" {
            tag = .itemPubDate
        } else {
            tag = .none
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "channel" {
            parser.abortParsing()
//            feedTableView.reloadData()
        } else if elementName == "item" {
            results.articles.append(current)
            current = ItemModel()
            isTagInItem = false
        } else {
            tag = .none
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch tag {
        case .chTitle:
            results.title = string
        case .chLastBuildDate:
            results.lastBuildDate = string
        case .itemTitle:
            current.title += string
        case .itemLink:
            current.link += string
        case .itemPubDate:
            current.pubDate = string
        case .itemDescription:
            current.description += string
        default:
            break
        }
    }
}

class ImageParser: NSObject, XMLParserDelegate {
    var parser = XMLParser()
    var originUrl: String = ""
    var imageURL: String = ""
    override init() {
        super.init()
    }
    
    init(url: String) {
        super.init()
        self.originUrl = url
        guard let hasUrl = URLComponents(string: self.originUrl)?.url else {
            return
        }
        guard let parser = XMLParser(contentsOf: hasUrl) else {
            return
        }
        parser.delegate = self
        parser.parse()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "meta" {
            if let hasImage = attributeDict["property"], hasImage == "og:image" {
                imageURL = attributeDict["content"] ?? ""
            }
        }
    }
    
    func urlToImage() -> UIImage? {
        if let url = URL(string: imageURL) {
            if let imgData = try? Data(contentsOf: url) {
                return UIImage(data: imgData)
            } else {
                return UIImage(named: "No_Img.png")
            }
        } else {
            return UIImage(named: "No_Img.png")
        }
    }
}


// MARK: - Setting AttributedString
extension String {
    func loadHTML() -> NSAttributedString? {
        let style = """
                    <style>
                    * {
                        font-size: 17px;
                        font-family: AppleSDGothicNeo-Regular;
                        white-space: nowrap;
                    }
                    p.contents {
                        color: #222222;
                    }
                    li {
                        overflow: hidden;
                        color: #97d1cb;
                    }
                    </style>
        """
        let addedStyle = "\(style) \(self)"
        guard let data = addedStyle.data(using: .unicode) else {
            print("guarded")
            return nil
        }
        do {
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributed
        } catch {
            print("error => \(error)")
            return nil
        }
        
    }
}
