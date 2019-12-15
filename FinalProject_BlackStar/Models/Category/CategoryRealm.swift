//
//  CategoryRealm.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 01.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryRealm: Object, Category {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var image: String?
    @objc dynamic var iconImage: String?
    @objc dynamic var iconImageActive: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
