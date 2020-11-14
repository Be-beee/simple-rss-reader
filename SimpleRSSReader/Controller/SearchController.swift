//
//  SearchController.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet var subscribeButton: UIButton!
    @IBOutlet var resultFeeds: UITableView!
    @IBOutlet var resultFeedTitle: UILabel!
    
    var parser = RSSParser()
    var searching = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "탐색"
        
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "URL을 입력하세요"
        self.navigationItem.searchController = searchController
        
        resultFeeds.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    }
    
    
    @IBAction func subscribeFeeds(_ sender: UIButton) {
        if subscribeMenu.contains(where: { $0.url == searching }) {
            let alert = UIAlertController(title: "알림", message: "이미 구독 중인 피드입니다!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        } else {
            let urlInfo = URLInfo(title: parser.results.title, url: searching)
            subscribeMenu.append(urlInfo)
            saveData(data: subscribeMenu, at: "subscribe")
            let alert = UIAlertController(title: "알림", message: "구독했습니다!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: - Extensions

extension SearchController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let hasText = searchBar.text {
            if !hasText.isEmpty {
                parser = RSSParser(url: hasText)
                if parser.results.articles.isEmpty {
                    let alert = UIAlertController(title: "알림", message: "검색 결과가 없습니다.", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    resultFeedTitle.text = parser.results.title
                    subscribeButton.isEnabled = true
                    searching = hasText
                    DispatchQueue.global().async {
                        for item in self.parser.results.articles {
                            let imageParser = ImageParser(url: item.link)
                            item.image = imageParser.urlToImage()
                        }
                        DispatchQueue.main.async {
                            self.resultFeeds.reloadData()
                        }
                    }
                }
                
            }
        }
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parser.results.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = resultFeeds.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return UITableViewCell() }
        cell.title.text = parser.results.articles[indexPath.row].title
        cell.feedCover.image = parser.results.articles[indexPath.row].image
        return cell
    }
}
