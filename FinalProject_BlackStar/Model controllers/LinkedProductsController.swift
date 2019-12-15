//
//  LinkedProductsController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 15.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class LinkedProductsController {
    
    let productID: String
    
    private var productsWithOtherColors: Results<ProductRealm>
    private var recommendedProducts: Results<ProductRealm>
    
    init(productID: String) {
        self.productID = productID
        let product = Realm.main.object(ofType: ProductRealm.self, forPrimaryKey: productID)!
        
        let recommendedIDs: [String] = product.recommendedProductIDs.map{ $0 }
        
        productsWithOtherColors = Realm.main.objects(ProductRealm.self).filter(NSPredicate(format: "article == %@", product.article))
        recommendedProducts = Realm.main.objects(ProductRealm.self).filter(NSPredicate(format: "id IN %@", recommendedIDs))
        
    }
    
    var numberOfColors: Int {
        productsWithOtherColors.count
    }
    
    var numberOfRecommendedProducts: Int {
        recommendedProducts.count
    }
    
    func color(at index: Int) -> (colorName: String, colorImageURL: String?) {
        let product = productsWithOtherColors[index]
        return (product.colorName, product.colorImageURL)
    }
    
    func recomendedProduct(at index: Int) -> ProductPresentation {
        recommendedProducts[index].presentation
    }
    
}
