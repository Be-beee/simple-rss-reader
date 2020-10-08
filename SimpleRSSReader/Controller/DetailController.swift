//
//  DetailController.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit
import SafariServices

class DetailController: UIViewController {
    
    @IBOutlet var articleTitleLabel: UILabel!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleContent: UILabel!
    
    var detailArticle = ItemModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailArticle.description = """
                    <p class = "contents">\(detailArticle.description)</p>
        """
        configureUI()
    }
    
    func configureUI() {
        articleTitleLabel.text = detailArticle.title
        articleImage.image = detailArticle.image
        articleContent.attributedText = detailArticle.description.loadHTML()
    }
    
//    @IBAction func visitWebsite(_ sender: UIButton) {
//        guard let url = URL(string: detailArticle.link) else {
//            return
//        }
//        let safariVC = SFSafariViewController(url: url)
//        self.present(safariVC, animated: true, completion: nil)
//        let vc = SFSafariViewController(url: URL(string: detailArticle.link)!)
//        self.present(vc, animated: true, completion: nil)
//    }
    
    
}
