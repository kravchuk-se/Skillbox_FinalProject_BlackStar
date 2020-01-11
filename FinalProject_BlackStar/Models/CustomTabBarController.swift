//
//  CustomTabBarController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 06.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    private var cartTabBarItem: UITabBarItem!
    private var previousCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .systemRed
        tabBar.unselectedItemTintColor = .label
        
        cartTabBarItem = viewControllers![1].tabBarItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTabBarItem), name: Cart.cartUpdateNotification, object: nil)
        
        updateTabBarItem()
    }

    private func animateAddNewItem() {
        if let image = tabBar.getImageViewForTabAt(index: 1) {
            image.transform = image.transform.rotated(by: .pi * (15/180))
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                image.transform = .identity
            }, completion: nil)
        }
    }
    
    @objc func updateTabBarItem() {
        cartTabBarItem.badgeValue = Cart.current.numberOfItems == 0 ? nil : String(Cart.current.numberOfItems)
        
        if let previousCount = previousCount, previousCount < Cart.current.numberOfItems {
            
            animateAddNewItem()
        }
        
        previousCount = Cart.current.numberOfItems
    }
    
}
