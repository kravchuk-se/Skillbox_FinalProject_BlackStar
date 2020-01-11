//
//  ProductsTableViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class ProductsCollectionViewController: UICollectionViewController {

    private enum LayoutSizeClass: Int {
        case large = 1
        case medium = 2
        case small = 3
    }
    
    var productsController: ProductsController!
    var subcategory: Subcategory!
    private var fetchInProgress = false
    
    private let indexOfLoadingSection = 1
    private let indexOfProductsSection = 0
    
    private var currentLayout: LayoutSizeClass = .medium {
        didSet {
            updateCollectionViewLayout()
        }
    }
    
    private let cellAspectRatio: CGFloat = 1.625396825396825
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentLayout = LayoutSizeClass(rawValue: Settings.productsGallerySizeClass) ?? .medium
        
        collectionView.register(
            UINib(nibName: ProductCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        productsController = ProductsController(subcategory: subcategory)
        productsController.delegate = self
        productsController.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCollectionViewLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        productsController.beginObserve()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        productsController.stopObserve()
        
        Settings.productsGallerySizeClass = currentLayout.rawValue
    }
    
    // MARK: - View conroller events
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.updateCollectionViewLayout()
        })
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
            
            return collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCell", for: indexPath)
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier,
                for: indexPath) as! ProductCollectionViewCell
            
            cell.configure(with: productsController.object(at: indexPath.item))
            
            return cell
            
        }
        
    }
    
    // MARK: - Collection view delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == indexOfProductsSection {
            performSegue(withIdentifier: "Select Product", sender: collectionView.cellForItem(at: indexPath))
        }
    }
    
    // MARK: - Actions
    
    @IBAction func pinchGestureTriggered(_ sender: UIPinchGestureRecognizer) {
        
        switch sender.state {
        case .ended:
            if sender.scale > 1.0 {
                increaseCellSize()
            } else if sender.scale < 1.0 {
                decreaseCellSize()
            }
        default:
            break
        }
        
    }
    
    // MARK: - Functions
    
    private func updateCollectionViewLayout() {
        let sectionInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        let safeSize = collectionView.frame.inset(by: view.safeAreaInsets)
        let minimumInteritemSpacing: CGFloat = 5.0
        
        let newLayout = UICollectionViewFlowLayout()
        newLayout.sectionInset = sectionInsets
        newLayout.minimumInteritemSpacing = minimumInteritemSpacing
        
        if traitCollection.verticalSizeClass == .compact {
            
            let cellHeight = safeSize.height
            let cellWidth = safeSize.height / cellAspectRatio
            
            newLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            
            collectionView.setCollectionViewLayout(newLayout, animated: true)
            
        } else {
        
            let numberOfColumns = currentLayout.rawValue
            
            let cellWidth = (safeSize.width - (sectionInsets.left + sectionInsets.right) - (minimumInteritemSpacing * CGFloat(numberOfColumns - 1))) / CGFloat(numberOfColumns)
            let cellHeight = cellWidth * cellAspectRatio
         
            newLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            
            collectionView.setCollectionViewLayout(newLayout, animated: true)
        }
    }
    
    private func increaseCellSize() {
        switch currentLayout {
        case .large:
            break
        case .medium:
            currentLayout = .large
        case .small:
            currentLayout = .medium
        }
    }
    
    private func decreaseCellSize() {
        switch currentLayout {
        case .large:
            currentLayout = .medium
        case .medium:
            currentLayout = .small
        case .small:
            break
        }
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
