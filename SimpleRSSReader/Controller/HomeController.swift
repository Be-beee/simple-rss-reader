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
    @IBOutlet var feedTableView: UITableView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var delegate: HomeControllerDelegate?
    var parser = RSSParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureNavigationBar()
        startSpinner()
        feedTableView.register(FeedCell.self, forCellReuseIdentifier: feedCellIdentifier)
        if !subscribeMenu.isEmpty {
            configureXMLParser(0)
            appendImageInfo()
        }
        stopSpinner()
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func moveToSearchView() {
        let searchView = UIStoryboard(name: "SearchController", bundle: nil).instantiateViewController(withIdentifier: "SearchController") as! SearchController
        
        self.navigationController?.pushViewController(searchView, animated: true)
    }
    
    
    // MARK:- Configure UI
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.barStyle = .default
        
        navigationItem.title = "Today"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "hamburgerline.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search.png")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(moveToSearchView))
    }
    
    func configureXMLParser(_ index: Int) {
        parser = RSSParser(url: subscribeMenu[index].url)
        feedTableView.reloadData()
    }

    func startSpinner() {
        parser.results.articles = []
        feedTableView.reloadData()
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        spinner.stopAnimating()
    }
    
    func appendImageInfo() {
        for item in parser.results.articles {
            let imageParser = ImageParser(url: item.link)
            item.image = imageParser.urlToImage()
        }
        feedTableView.reloadData()
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
        return parser.results.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedTableView.dequeueReusableCell(withIdentifier: feedCellIdentifier, for: indexPath) as! FeedCell
        cell.feedCover.image = parser.results.articles[indexPath.row].image
        cell.title.text = parser.results.articles[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailView = UIStoryboard(name: "DetailController", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        detailView.detailArticle = parser.results.articles[indexPath.row]
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}
