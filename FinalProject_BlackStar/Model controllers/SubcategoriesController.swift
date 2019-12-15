//
//  SubcategoriesController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 01.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

class SubcategoriesController {
    
    private var categoryID: String
    weak var delegate: SubcategoriesControllerDelegate?
    
    init(categoryID: String) {
        self.categoryID = categoryID
        
        results = Realm.main.objects(SubcategoryRealm.self).sorted(byKeyPath: "sortOrder").filter(NSPredicate(format: "category.id == %@", categoryID))
    }
    
    // MARK: - Data access
    
    private var results: Results<SubcategoryRealm>
    
    func object(at index: Int) -> Subcategory {
        return results[index]
    }
    
    var numberOfObjects: Int { return results.count }
    
    // MARK: - Notifications, updates
    
    var notificationToken: NotificationToken?
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
            
            weakself.delegate?.didUpdateData(weakself, changes: batchUpdate)        }
    }
    
    func stopObserve() {
        notificationToken?.invalidate()
    }
    
}

protocol SubcategoriesControllerDelegate: class {
    func didUpdateData(_ controller: SubcategoriesController, changes: BatchUpdate)
    func didUpdateData(_ controller: SubcategoriesController)
    func fetchDidBegin(_ controller: SubcategoriesController)
    func fetchDidEnd(_ controller: SubcategoriesController, error: Error?)
}
