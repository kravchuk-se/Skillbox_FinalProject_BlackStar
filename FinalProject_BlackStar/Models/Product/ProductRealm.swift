//
//  ProductRealm.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 08.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class ProductRealm: Object {
    
    @objc dynamic var subcategory: SubcategoryRealm?
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var sortOrder: Int = 0
    @objc dynamic var article: String = ""
    @objc dynamic var productDescription: String = ""
    @objc dynamic var colorName: String = ""
    @objc dynamic var colorImageURL: String? = nil
    @objc dynamic var mainImage: String? = nil
    let productImages = List<ProductImageRealm>()
    let offers        = List<OfferRealm>()
    let attributes    = List<ProductAttributeRealm>()
    let recommendedProductIDs = List<String>()
    @objc dynamic var price: Double = 0
    @objc dynamic var tag: String? = nil

    override static func primaryKey() -> String? {
        return "id"
    }
}

class OfferRealm: Object {
    @objc dynamic var size: String = ""
    @objc dynamic var productOfferID: String = ""
    @objc dynamic var quantity: Int = 0
    
    override class func primaryKey() -> String? {
        return "productOfferID"
    }
}

class ProductImageRealm: Object {
    @objc dynamic var imageURL: String = ""
    @objc dynamic var sortOrder: Int = 0

    override static func primaryKey() -> String? {
        return "imageURL"
    }
}

class ProductAttributeRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var value: String = ""
    
    override class func primaryKey() -> String? {
        return "name"
    }
}
