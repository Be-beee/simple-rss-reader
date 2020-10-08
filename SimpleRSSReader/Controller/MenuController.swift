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

    @IBOutlet weak var menuTableView: UITableView!
    var delegate: HomeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTableView.reloadData()
    }
    
    func configureTableView() {
        menuTableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        menuTableView.backgroundColor = .darkGray
        menuTableView.rowHeight = 80
    }

}

// MARK: - Extensions

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MenuOptionCell
        
        let menuOption = subscribeMenu[indexPath.row]
        cell.descriptionLabel.text = menuOption.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = indexPath.row
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            subscribeMenu.remove(at: indexPath.row)
            menuTableView.reloadData()
            saveData(data: subscribeMenu, at: "subscribe")
        }
    }
}
