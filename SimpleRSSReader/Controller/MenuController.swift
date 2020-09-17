//
//  MenuController.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MenuOptionCell"

class MenuController: UIViewController {

    var menuTable: UITableView!
    var delegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        menuTable = UITableView()
        menuTable.delegate = self
        menuTable.dataSource = self
        
        menuTable.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        menuTable.backgroundColor = .darkGray
        menuTable.separatorStyle = .none
        menuTable.rowHeight = 80
        
        view.addSubview(menuTable)
        menuTable.translatesAutoresizingMaskIntoConstraints = false
        menuTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        menuTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        menuTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        menuTable.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }

}

// MARK: - Extensions

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
    
}
