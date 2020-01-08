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
    private var fetchInProgress = false
    
    private let indexOfLoadingSection = 1
    private let indexOfProductsSection = 0
    
    private var cellSizeV: CGSize = CGSize.zero
    private var scale: CGFloat = 0.4 {
        didSet {
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    private let minScale: CGFloat = 0.6
    private let maxScale: CGFloat = 2.0
    private let cellAspectRatio: CGFloat = 1.625396825396825
    
    private var previousSizeClass: UIUserInterfaceSizeClass?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scale = CGFloat(Settings.productsGalleryScaleFactor)
        
        calculateBaseCellSize()
        
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
        
        Settings.productsGalleryScaleFactor = Float(scale)
    }
    
    // MARK: - View conroller events
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Collection view data source
    
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
    
    // MARK: - Actions
    
    @IBAction func pinchGestureTriggered(_ sender: UIPinchGestureRecognizer) {
        
        switch sender.state {
        case .changed, .ended:
            
            let newScale = scale * sender.scale
            
            scale = min(max(minScale, newScale), maxScale)
            
            sender.scale = 1.0

            
        default:
            break
        }
        
    }
    
    // MARK: - Functions
    
    private func calculateBaseCellSize() {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!.sectionInset
        let safeSize = collectionView.frame.inset(by: view.safeAreaInsets).inset(by: insets)
        
        
        let cellWidth = (safeSize.width / 2 - 4)
        let cellHeight = cellWidth * cellAspectRatio
        
        cellSizeV = CGSize(width: cellWidth,
                           height: cellHeight)
    }
    
    // MARK: - Navigation
    
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
        
        if previousSizeClass != traitCollection.verticalSizeClass {
            previousSizeClass = traitCollection.verticalSizeClass
            calculateBaseCellSize()
        }
        
        if traitCollection.verticalSizeClass == .compact {
            let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!.sectionInset
            let safeSize = collectionView.frame.inset(by: view.safeAreaInsets).inset(by: insets)
            return CGSize(width: safeSize.height / cellAspectRatio,
                          height: safeSize.height)
        } else {
            return cellSizeV.scaled(by: scale)
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
