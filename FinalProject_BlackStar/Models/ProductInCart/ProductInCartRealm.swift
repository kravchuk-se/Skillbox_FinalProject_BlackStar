//
//  ProductInCartRealm.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 18.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class ProductInCartRealm: Object {
    
    @objc dynamic var product: ProductRealm?
    @objc dynamic var offer: OfferRealm?
    
}
