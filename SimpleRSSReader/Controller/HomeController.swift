//
//  ViewController.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

private let feedCellIdentifier = "FeedCell"

class HomeController: UIViewController {

    var delegate: HomeControllerDelegate?
    
    var feed = RSSModel()
    var feedTableView: UITableView!
    var current = ItemModel()
    var isTagInItem: Bool = false //현재 태그 위치가 <channel>, <item> 중 어디 내부인지 표시
    var tag: Tag = .none
    
    var parser = XMLParser()
    var urls: [String] = []
    var testURL = "https://be-beee.tistory.com/rss"
    
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urls = [
            "https://news.google.com/rss?hl=ko&gl=KR&ceid=KR:ko", // google news
            "https://www.nintendolife.com/feeds/latest", // nintendo news
            "http://www.yes24.com/_par_/Rss/KBO001001003.xml", // new books list - IT
            "https://be-beee.tistory.com/rss" // my blog
        ]
        
        view.backgroundColor = .white
        configureNavigationBar()
        configureFeedTableView()
        configureXMLParser(0)
        configureSpinner()
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    
    // MARK:- Configure UI
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .default
        
        navigationItem.title = "Today"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburgerline.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
    
    func configureFeedTableView() {
        feedTableView = UITableView()
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        feedTableView.register(FeedCell.self, forCellReuseIdentifier: feedCellIdentifier)
        feedTableView.separatorStyle = .none
        
        view.addSubview(feedTableView)
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        feedTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        feedTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        feedTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    func configureXMLParser(_ index: Int) {
        guard let url = URLComponents(string: urls[index])?.url else {
            return
        }
        guard let parser = XMLParser(contentsOf: url) else {
            return
        }
        parser.delegate = self
        parser.parse()
    }
    
    func configureSpinner() {
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func startSpinner() {
        feed.articles = []
        feedTableView.reloadData()
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
}

// MARK: - Extensions

extension HomeController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
extension HomeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: feedCellIdentifier, for: indexPath) as! FeedCell
        cell.title.text = feed.articles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = DetailController()
        detailView.detailArticle = feed.articles[indexPath.row]
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}

extension HomeController: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        // 시작태그를 만났을 때 호출
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
        // 종료 태그를 만났을 때 호출
        
        if elementName == "channel" {
            parser.abortParsing()
            feedTableView.reloadData()
        } else if elementName == "item" {
            feed.articles.append(current)
            current = ItemModel()
            isTagInItem = false
        } else {
            tag = .none
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // 현재 태그에 담겨있는 문자열 전달
        switch tag {
        case .chTitle:
            feed.title = string
        case .chLastBuildDate:
            feed.lastBuildDate = string
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
