//
//  SubcategoryRealm.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 01.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class SubcategoryRealm: Object, Subcategory {
    @objc dynamic var category:  CategoryRealm?
    @objc dynamic var id:        String = ""
    @objc dynamic var iconImage: String = ""
    @objc dynamic var sortOrder: Int    = 0
    @objc dynamic var name:      String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
