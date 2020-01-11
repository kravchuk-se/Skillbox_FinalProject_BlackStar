//
//  Settings.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 08.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import Foundation

struct Settings {
    static var productsGallerySizeClass: Int {
        get {
            return UserDefaults.standard.integer(forKey: sizeClassKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: sizeClassKey)
        }
    }
    private static let sizeClassKey = "Settings.productsGallerySizeClass"
}
