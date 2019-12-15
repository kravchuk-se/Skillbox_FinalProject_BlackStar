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
        
        let url = URL(string: "http://blackstarshop.ru/index.php?route=api/v1/categories")!
        delegate?.fetchDidBegin(self)

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    var categoriesById = try JSONDecoder().decode([String: CategoryJSON].self, from: data)
                    categoriesById.keys.forEach { key in
                        categoriesById[key]!.id = key
                    }
                    self.replaceCategories(with: categoriesById.values.map({$0}))
                } catch {
                    print(error)
                }
            }
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                self.delegate?.fetchDidEnd(self, error: error)
            }
        }.resume()
    }
    
    private func replaceCategories(with categories: [CategoryJSON]) {
        DispatchQueue.global().async {[categories] in
            
            let realm = try! Realm()
            
            let objects = realm.objects(CategoryRealm.self)
            for obj in objects {
                if !categories.contains(where: { $0.id == obj.id }) {
                    try! realm.write {
                        realm.delete(obj)
                    }
                }
            }
            
            try! realm.write {
                
                var collections: [SubcategoryJSON] = []
                
                categories.forEach { categoryJSON in
                    let newCategory = CategoryRealm()
                    newCategory.id              = categoryJSON.id
                    newCategory.name            = categoryJSON.name
                    newCategory.iconImage       = categoryJSON.iconImage
                    newCategory.iconImageActive = categoryJSON.iconImageActive
                    newCategory.image           = categoryJSON.image
                    newCategory.sortOrder       = categoryJSON.sortOrder
                    
                    realm.add(newCategory, update: .modified)
                    
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
                            
                            realm.add(newSubcategory, update: .modified)
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
                            
                            realm.add(newSubcategory, update: .modified)
                            
                        }
                    }
                    
                }
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
