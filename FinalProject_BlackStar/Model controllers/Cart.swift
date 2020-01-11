//
//  Cart.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 30.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

typealias ProductInCartPresentation = (product: ProductPresentation, offer: OfferPresentation)

class Cart {

    static var current: Cart = Cart()
    static let cartUpdateNotification = Notification.Name("Cart.CartUpdated")
    
    private var products: Results<ProductInCartRealm>
    private var token: NotificationToken?
    
    init() {
        products = Realm.main.objects(ProductInCartRealm.self)
        token = products.observe() { changes in
            
            NotificationCenter.default.post(Notification(name: Cart.cartUpdateNotification))
            
        }
    }
    
    func addToCart(_ item: ProductPresentation, offer: OfferPresentation) {
        
        guard let product = Realm.main.object(ofType: ProductRealm.self, forPrimaryKey: item.id),
            let offer = product.offers.filter({ $0.productOfferID == offer.productOfferID }).first
            else {
                return
        }
        
        try! Realm.main.write {
            let newItem = ProductInCartRealm()
            newItem.product = product
            newItem.offer = offer
            
            Realm.main.add(newItem)
        }
        
    }
    
    var numberOfItems: Int {
        products.count
    }
    
    func object(at index: Int) -> ProductInCartPresentation {
        assert(index < products.count, "Index out of the bounds")
        
        return (products[index].product!.presentation, products[index].offer!.presentation)
    }
    
    func remove(at index: Int) {
        assert(index < products.count, "Index out of the bounds")
        
        try! Realm.main.write {
            Realm.main.delete(products[index])
        }
        
    }
    
    deinit {
        print("the Cart was successfully deinitialized")
    }
    
}

protocol CartObserver {
    func didUpdateData(_ cart: Cart, changes: BatchUpdate)
}
