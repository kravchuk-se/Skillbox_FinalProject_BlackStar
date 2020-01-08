//
//  CustomTabBarController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 06.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    var cartTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .label
        
        cartTabBarItem = viewControllers![1].tabBarItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTabBarItem), name: Cart.cartUpdateNotification, object: nil)
        
        updateTabBarItem()
    }

    @objc func updateTabBarItem() {
        cartTabBarItem.badgeValue = Cart.current.numberOfItems == 0 ? nil : String(Cart.current.numberOfItems)
    }
    
}
