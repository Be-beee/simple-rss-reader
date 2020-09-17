//
//  DetailController.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    var detailArticle = ItemModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailArticle.description = """
                    <p class = "contents">\(detailArticle.description)</p>
        """
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
//        Setting UI
        let title = UILabel()
        title.text = detailArticle.title
        title.font = UIFont.systemFont(ofSize: 21)
        title.lineBreakMode = .byWordWrapping
        title.numberOfLines = 0
        
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        title.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        let articleImage = UIImageView()
        articleImage.image = UIImage(named: "No_Img.png")
        articleImage.clipsToBounds = true
        articleImage.contentMode = .scaleAspectFill
        
        view.addSubview(articleImage)
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15).isActive = true
        articleImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        articleImage.heightAnchor.constraint(equalToConstant: 250).isActive = true
        articleImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        
        let descriptionView = UITextView()
        descriptionView.text = detailArticle.description
        descriptionView.font = UIFont.systemFont(ofSize: 16)
        descriptionView.isEditable = false
        descriptionView.attributedText = detailArticle.description.loadHTML()

        
        view.addSubview(descriptionView)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.topAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: 15).isActive = true
        descriptionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        descriptionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        descriptionView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
}
