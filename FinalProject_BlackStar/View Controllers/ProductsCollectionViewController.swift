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
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? productsController.numberOfObjects : 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier,
            for: indexPath) as! ProductCollectionViewCell
        
        cell.configure(with: productsController.object(at: indexPath.item))
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Select Product":
            
            let vc = segue.destination as! ProductViewController
            let cell = sender as! ProductCollectionViewCell
            let indexPath = collectionView.indexPath(for: cell)!
                
            vc.product = productsController.object(at: indexPath.item)
            vc.mainImage = cell.productImageView.image
            vc.transitioningDelegate = self
            
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
        performSegue(withIdentifier: "Select Product", sender: collectionView.cellForItem(at: indexPath))
    }
}

extension ProductsCollectionViewController: ProductsControllerDelegate {
    func didUpdateData(_ controller: ProductsController, changes: BatchUpdate) {
        
        switch changes {
        case .initial:
            
            if collectionView.numberOfItems(inSection: 0) != productsController.numberOfObjects {
                collectionView.reloadData()
            }
            
        case .update(let deletions, let insertion, let modifications):
            
            collectionView.performBatchUpdates({
                collectionView.deleteItems(at: deletions.map({IndexPath(item: $0, section: 0)}))
                collectionView.insertItems(at: insertion.map({IndexPath(item: $0, section: 0)}))
                collectionView.reloadItems(at: modifications.map({IndexPath(item: $0, section: 0)}))
            }, completion: nil)
            
        case .error(_):
            break
        }
        
    }
    
    func didUpdateData(_ controller: ProductsController) {
        collectionView.reloadData()
    }
    
    func fetchDidBegin(_ controller: ProductsController) {
        
    }
    
    func fetchDidEnd(_ controller: ProductsController, error: Error?) {
        
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension ProductsCollectionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let cell = collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell else {
            return nil
        }
        
        transition.originFrame = collectionView.convert(cell.frame, to: nil)
        transition.presenting = true
        
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = false
        
        return transition
    }
}
