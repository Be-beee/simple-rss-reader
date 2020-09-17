//
//  FeedCell.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    let feedCover: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "No_Img.png") ?? UIImage()
        return imgView
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.text = "Title"
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(feedCover)
        feedCover.translatesAutoresizingMaskIntoConstraints = false
        feedCover.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        feedCover.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        feedCover.heightAnchor.constraint(equalToConstant: 110).isActive = true
        feedCover.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: feedCover.rightAnchor, constant: 15).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
