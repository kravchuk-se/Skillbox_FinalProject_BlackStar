//
//  ProductsTableViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class ProductsCollectionViewController: UICollectionViewController {

    var productsController: ProductsController!
    var subcategory: Subcategory!
    var fetchInProgress = false
    
    private let indexOfLoadingSection = 1
    private let indexOfProductsSection = 0
    
    let transition = PopAnimator()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(
            UINib(nibName: ProductCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        productsController = ProductsController(subcategory: subcategory)
        productsController.delegate = self
        productsController.fetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productsController.beginObserve()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        productsController.stopObserve()
    }
    
    // MARK: - View conroller events
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case indexOfLoadingSection:
            return fetchInProgress ? 1 : 0
        case indexOfProductsSection:
            return productsController.numberOfObjects
        default:
            return 0
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == indexOfLoadingSection {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier,
                for: indexPath) as! ProductCollectionViewCell
            
            cell.configure(with: productsController.object(at: indexPath.item))
            
            return cell
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Select Product":
            
            let vc = segue.destination as! ProductViewController
            let cell = sender as! ProductCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
                
            vc.product = productsController.object(at: indexPath.item)
            vc.mainImage = cell.productImageView.image
            
        default:
            break
        }
    }
    
}

extension ProductsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!.sectionInset
        let safeSize = collectionView.frame.inset(by: view.safeAreaInsets).inset(by: insets)
        
        if traitCollection.verticalSizeClass == .compact {
            return CGSize(width: (safeSize.width / 4) - 4,
                          height: safeSize.height)
        } else {
            return CGSize(width: (safeSize.width / 2) - 4,
                          height: (safeSize.height / 2))
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == indexOfProductsSection {
            performSegue(withIdentifier: "Select Product", sender: collectionView.cellForItem(at: indexPath))
        }
    }
}

extension ProductsCollectionViewController: ProductsControllerDelegate {
    func didUpdateData(_ controller: ProductsController, changes: BatchUpdate) {
        
        switch changes {
        case .initial:
            
            if collectionView.numberOfItems(inSection: indexOfProductsSection) != productsController.numberOfObjects {
                collectionView.reloadData()
            }
            
        case .update(let deletions, let insertion, let modifications):
            
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: deletions.map({IndexPath(item: $0, section: indexOfProductsSection)}))
                collectionView.insertItems(at: insertion.map({IndexPath(item: $0, section: indexOfProductsSection)}))
                collectionView.reloadItems(at: modifications.map({IndexPath(item: $0, section: indexOfProductsSection)}))
            }, completion: nil)
            
        case .error(_):
            break
        }
        
    }
    
    func didUpdateData(_ controller: ProductsController) {
        collectionView.reloadData()
    }
    
    func fetchDidBegin(_ controller: ProductsController) {
        fetchInProgress = true
        collectionView.reloadSections([indexOfLoadingSection])
    }
    
    func fetchDidEnd(_ controller: ProductsController, error: Error?) {
        fetchInProgress = false
        collectionView.reloadSections([indexOfLoadingSection])
    }
}
