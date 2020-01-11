//
//  UITabBar+.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 11.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

extension UITabBar {

    func getFrameForTabAt(index: Int) -> CGRect? {
        if let tab = getTabViewAt(index: index) {
            return tab.frame
        }
        return nil
    }

    func getFrameForTabImageAt(index: Int) -> CGRect? {
        if let tab = getTabViewAt(index: index),
            let imageView = getImageViewForTabAt(index: index) {
                return tab.convert(imageView.frame, to: self)
        }
        return nil
    }
    
    func getTabViewAt(index: Int) -> UIView? {
        var tabs = self.subviews.compactMap({ $0 as? UIControl })
        tabs.sort(by: { $0.frame.origin.x < $1.frame.origin.y })
        if index < tabs.count {
            return tabs[index]
        }
        return nil
    }
    
    func getImageViewForTabAt(index: Int) -> UIImageView? {
        if let tab = getTabViewAt(index: index) {
            return tab.subviews.compactMap({ $0 as? UIImageView }).first
        }
        return nil
    }
    
}
