//
//  CategoriesController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class CategoriesController {
    
    weak var delegate: CategoriesControllerDelegate?
   
    // MARK: - Data access
    
    lazy private var results = Realm.main.objects(CategoryRealm.self).sorted(byKeyPath: "sortOrder")
   
    func object(at index: Int) -> Category {
        return results[index]
    }
    
    var numberOfObjects: Int { return results.count } 
    
    // MARK: - Notifications, updates
    
    private var notificationToken: NotificationToken?
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
    
    // MARK: - Request data from server
    
    func fetch() {
        
        delegate?.fetchDidBegin(self)
     
        BlackStarAPI.fetch(.categories, completion: { (result: BlackStarAPI.Result<[String: CategoryJSON]>) in
            switch result {
            case .success(let value):
                self.replaceCategories(with: value)
                DispatchQueue.main.async {
                    self.delegate?.fetchDidEnd(self, error: nil)
                }
            case .fail(let error):
                DispatchQueue.main.async {
                    self.delegate?.fetchDidEnd(self, error: error)
                }
            }
        })
    }
    
    private func replaceCategories(with categoriesByID: [String: CategoryJSON]) {
        DispatchQueue.global().async {
            
            let realm = try! Realm()
            
            let oldCategories = realm.objects(CategoryRealm.self)
                .filter( { categoriesByID[$0.id] == nil } )
            
            try! realm.write {
                for category in oldCategories {
                    realm.delete(category)
                }
            }
            
            var newCategories: [CategoryRealm] = []
            var newSubcategoies: [SubcategoryRealm] = []
            
            var collections: [SubcategoryJSON] = []
            
            for (id, categoryJSON) in categoriesByID {
                let newCategory = CategoryRealm()
                newCategory.id              = id
                newCategory.name            = categoryJSON.name
                newCategory.iconImage       = categoryJSON.iconImage
                newCategory.iconImageActive = categoryJSON.iconImageActive
                newCategory.image           = categoryJSON.image
                newCategory.sortOrder       = categoryJSON.sortOrder
                
                newCategories.append(newCategory)
                
                for subcategory in categoryJSON.subcategories {
                    
                    if subcategory.type == "Collection" {
                        collections.append(subcategory)
                    } else {
                        let newSubcategory = SubcategoryRealm()
                        newSubcategory.category  = newCategory
                        newSubcategory.id        = subcategory.id
                        newSubcategory.name      = subcategory.name
                        newSubcategory.sortOrder = subcategory.sortOrder
                        newSubcategory.iconImage = subcategory.iconImage
                        
                        newSubcategoies.append(newSubcategory)
                    }
                }
                
                if let collectionsCategory = realm.object(ofType: CategoryRealm.self, forPrimaryKey: "74") {
                    for collection in collections {
                        
                        let newSubcategory = SubcategoryRealm()
                        newSubcategory.category = collectionsCategory
                        newSubcategory.id = collection.id
                        newSubcategory.name = collection.name
                        newSubcategory.sortOrder = collection.sortOrder
                        newSubcategory.iconImage = collection.iconImage
                        
                        newSubcategoies.append(newSubcategory)
                        
                    }
                }
                
            }
            
            
            
            try! realm.write {
                
                realm.add(newCategories, update: .modified)
                realm.add(newSubcategoies, update: .modified)
                
            }
        }
    }
    
}

protocol CategoriesControllerDelegate: class {
    func didUpdateData(_ controller: CategoriesController, changes: BatchUpdate)
    func didUpdateData(_ controller: CategoriesController)
    func fetchDidBegin(_ controller: CategoriesController)
    func fetchDidEnd(_ controller: CategoriesController, error: Error?)
}
