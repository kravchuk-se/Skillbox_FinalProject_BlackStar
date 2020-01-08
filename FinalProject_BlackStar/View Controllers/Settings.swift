//
//  Settings.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 08.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import Foundation

struct Settings {
    static var productsGalleryScaleFactor: Float {
        get {
            let value = UserDefaults.standard.float(forKey: scaleFactorKey)
            return value == 0 ? 1 : value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: scaleFactorKey)
        }
    }
    private static let scaleFactorKey = "Settings.productsGalleryScaleFactor"
}
