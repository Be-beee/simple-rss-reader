//
//  ContainerController.swift
//  SimpleRSSReader
//
//  Created by 서보경 on 2020/09/11.
//  Copyright © 2020 서보경. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {

    var menuController: MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loaded = loadData(at: "subscribe") {
            subscribeMenu = loaded as! [URLInfo]
        }
        configureHomeController()
    }
    
    func configureHomeController() {
        let homeController = UIStoryboard(name: "HomeController", bundle: nil).instantiateViewController(withIdentifier: "HomeController") as! HomeController
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    func configureMenuController() {
        if menuController == nil {
            menuController = UIStoryboard(name: "MenuController", bundle: nil).instantiateViewController(withIdentifier: "MenuController") as? MenuController
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: Int?) {
        if shouldExpand {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else { return }
                self.didSelectMenuOption(menuOption: menuOption)
                self.view.layoutIfNeeded()
            }
        }
        
        animateStatusBar()
    }
    
    func didSelectMenuOption(menuOption: Int) {
        let home = centerController.children.first as! HomeController
        home.startSpinner()
        home.configureXMLParser(menuOption)
        home.appendImageInfo()
        home.stopSpinner()
    }
    
    func animateStatusBar() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Extensions

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: Int?) {
        if !isExpanded {
            configureMenuController()
        }
        isExpanded.toggle()
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
    }
}
