//
//  Cart.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 30.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation

class Cart {

    static var current: Cart = Cart()
    
    private (set) var products: [ProductInCart] = []
    
    func addToCart(_ item: ProductJSON, offer: OfferJSON) {
        products.append(ProductInCart(product: item, offer: offer))
    }
    
    func remove(at index: Int) {
        assert(index < products.count, "Index out of the bounds")
        products.remove(at: index)
    }
    
}

struct ProductInCart {
    let product: ProductJSON
    var offerID: String
    
    init(product: ProductJSON, offer: OfferJSON) {
        self.product = product
        self.offerID = offer.productOfferID
    }
    
}
