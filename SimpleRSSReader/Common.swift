//
//  Common.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

protocol HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?)
}

enum MenuOption: Int, CustomStringConvertible {
    case Google
    case Nintendo
    case Yes24Newbooks
    case MyBlog
    
    var description: String {
        switch self {
        case .Google: return "Google"
        case .Nintendo: return "Nintendo News"
        case .Yes24Newbooks: return "Yes24 New Books"
        case .MyBlog: return "My Blog"
        }
    }
}

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
    //var image: UIImage
    
    init() {
        title = ""
        link = ""
        pubDate = ""
        description = ""
    }
    
    init(title: String, link: String, pubDate: String, description: String) {
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.description = description
    }
}

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
