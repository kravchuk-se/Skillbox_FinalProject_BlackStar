//
//  UIViewController+.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 30.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var content: UIViewController {
        
        if let navCon = self as? UINavigationController {
            return navCon.topViewController!.content
        } else {
            return self
        }
        
    }
    
}
