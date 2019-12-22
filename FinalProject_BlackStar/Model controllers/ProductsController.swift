//
//  ProductsController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 26.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class ProductsController {
    
    private var results: Results<ProductRealm>!
    
    private let subcategory: Subcategory
    private let subcategoryId: String
    weak var delegate: ProductsControllerDelegate?
    
    private var notificationToken: NotificationToken?
    
    init(subcategory: Subcategory) {
        self.subcategory = subcategory
        self.subcategoryId = subcategory.id
        
        results = Realm.main.objects(ProductRealm.self).filter(NSPredicate(format: "subcategory.id == %@", subcategoryId))
        
    }
    
    func beginObserve() {
        notificationToken = results.observe {[weak self] change in
            guard let weakself = self else { return }
                
                let batchUpdate: BatchUpdate
                
                switch change {
                case .initial:
                    
                    batchUpdate = .initial
                    
                case .update(_, let deletions, let insertions, let modifications):
                    
                    batchUpdate = .update(
                        deletions: deletions,
                        insertions: insertions,
                        modifications: modifications)
                    
                case .error(let error):
                    
                    batchUpdate = .error(error)
                    
                }
            
            weakself.delegate?.didUpdateData(weakself, changes: batchUpdate)
        }
    }
    
    func stopObserve() {
        notificationToken?.invalidate()
    }
    
    func object(at index: Int) -> ProductPresentation {
        return results[index].presentation
    }
    
    var numberOfObjects: Int {
        return results.count
    }
    
    func fetch() {
        
        delegate?.fetchDidBegin(self)
        
        BlackStarAPI.fetch(.products(subcategoryID: subcategoryId)) { (result: BlackStarAPI.Result<[String: ProductJSON]>) in
            switch result {
            case .success(let value):
                self.replaceProducts(with: value)
                DispatchQueue.main.async {
                    self.delegate?.fetchDidEnd(self, error: nil)
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    self.delegate?.fetchDidEnd(self, error: error)
                }
            }
        }
        
    }
    
    private func replaceProducts(with products: [String: ProductJSON]) {
        
        let realm = try! Realm()
        
        let subcategory = realm.object(ofType: SubcategoryRealm.self, forPrimaryKey: self.subcategoryId)!
        
        let oldProducts = realm.objects(ProductRealm.self)
            .filter(NSPredicate(format: "subcategory.id == %@", subcategoryId))
            .filter( { products[$0.id] == nil } )
        
        try! realm.write {
            for product in oldProducts {
                realm.delete(product)
            }
        }
        
        var newProducts = [ProductRealm]()
        
        for (id, product) in products {
            let newProduct = ProductRealm()
            newProduct.subcategory        = subcategory
            newProduct.id                 = id
            newProduct.name               = product.name
            newProduct.productDescription = product.description
            newProduct.article            = product.article
            newProduct.colorName          = product.colorName
            newProduct.colorImageURL      = product.colorImageURL
            newProduct.mainImage          = product.mainImage
            newProduct.price              = product.price
            newProduct.tag                = product.tag
            
            newProducts.append(newProduct)
            
            for offer in product.offers {
                let newOffer = OfferRealm()
                newOffer.productOfferID = offer.productOfferID
                newOffer.quantity = offer.quantity
                newOffer.size = offer.size
                
                newProduct.offers.append(newOffer)
            }
            
            for image in product.productImages {
                let newImage = ProductImageRealm()
                newImage.imageURL = image.imageURL
                newImage.sortOrder = image.sortOrder
                
                newProduct.productImages.append(newImage)
            }
            
            if let attributes = product.attributes {
                for attibute in attributes {
                    for (key, value) in attibute {
                        
                        let newAttribute = ProductAttributeRealm()
                        newAttribute.name = key
                        newAttribute.value     = value
                        
                        newProduct.attributes.append(newAttribute)
                    }
                }
            }
            
            if let recomendedIDs = product.recommendedProductIDs {
                newProduct.recommendedProductIDs.append(objectsIn: recomendedIDs)
            }
        }
        
        try! realm.write {
            realm.add(newProducts, update: .modified)
        }
        
    }
    
}

protocol ProductsControllerDelegate: class {
    func didUpdateData(_ controller: ProductsController, changes: BatchUpdate)
    func didUpdateData(_ controller: ProductsController)
    func fetchDidBegin(_ controller: ProductsController)
    func fetchDidEnd(_ controller: ProductsController, error: Error?)
}
