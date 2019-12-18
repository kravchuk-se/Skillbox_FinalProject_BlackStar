//
//  ProductViewController.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var imagesContainerView: UIView!
    @IBOutlet weak var imagesScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagView: TagView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var colorPreview: ColorPreviewButton!
    
    @IBOutlet weak var productAttributesTextView: UITextView!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    @IBOutlet weak var selectSizeButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var recommendedProductsCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var needsToFetchImage = true
    var product: ProductPresentation!
    private var linkedProductsController: LinkedProductsController!
    var offer: OfferPresentation? {
        didSet {
            updateUI()
        }
    }
    
    var imageViews: [String:UIImageView] = [:]
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recommendedProductsCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        self.recommendedProductsCollectionView!.register(
            UINib(nibName: ProductCollectionViewCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        
        linkedProductsController = LinkedProductsController(productID: product.id)
        
        initializeImageViews()
        
        pageControl.numberOfPages = product.productImageURLs.count
        pageControl.currentPage = 0
        
        productNameLabel.text = product.name
        productDescriptionTextView.text = product.description
        
        priceLabel.text = product.price
        
        tagView.tagColor = product.tagColor
        tagView.tagText = product.tag
        
        colorPreview.colorNameLabel.text = product.colorName
        colorPreview.colorURL = product.colorImageURL
        
        productAttributesTextView.attributedText = product.attributesText(
            headlineFont: UIFont(name: "Helvetica-Bold", size: 14)!,
            descriptionFont: UIFont(name: "Helvetica", size: 14)!)
        
        recommendedProductsCollectionView.dataSource = self
        recommendedProductsCollectionView.delegate = self
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needsToFetchImage {
            fetchImages()
            needsToFetchImage = false
        }
    }
    
    // MARK: - Layout
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { context in
            self.updateImagesFrames()
        })
    }
    
    override func viewDidLayoutSubviews() {
        updateImagesFrames()
        
        addToCartButton.layer.cornerRadius = 5.0
    }
    
    func initializeImageViews() {
        imagesScrollView.delegate = self
        for imageURL in product.productImageURLs {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imagesScrollView.addSubview(imageView)
            imageViews[imageURL] = imageView
        }
    }
    
    func updateImagesFrames() {
        
        let imageCount = product.productImageURLs.count
        let w = imagesContainerView.frame.width
        let h = imagesContainerView.frame.height
        
        var offset: CGFloat = 0
    
        for imageURL in product.productImageURLs {
            imageViews[imageURL]!.frame = CGRect(x: offset,
                                     y: 0,
                                     width: w,
                                     height: h)
            offset += w
        }
        
        imagesScrollView.contentSize = CGSize(width: w * CGFloat(imageCount), height: h)
    }
    
    // MARK: - Functions
    
    func fetchImages() {
        for imageURL in product.productImageURLs {
            ImageProvider.loadImage(url: imageURL) {[imageURL] image in
                self.imageViews[imageURL]?.image = image
            }
        }
    }
    
    func updateUI() {
        
        if let offer = offer {
            selectSizeButton?.setTitle("Размер: \(offer.size)", for: .normal)
        } else {
            selectSizeButton?.setTitle("Размер", for: .normal)
        }
        
        colorPreview?.disclosureIndicator.isHidden = linkedProductsController.numberOfColors < 2
        
    }
    
    // MARK: - Navigation
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ChoseSize":
            
            self.definesPresentationContext = true
            
            let vc = segue.destination as! ModalPicker
            vc.pickerTitle = "Select size:"
            vc.options = product.offers.map { offer in (offer.productOfferID, offer.size, "\(offer.quantity)", false) }
            
            vc.onSelect = {[weak self] selectedOption in
                self?.offer = self?.product.offers.first(where: { $0.productOfferID == selectedOption.id })
                self?.dismiss(animated: true, completion: nil)
            }
        case "ChoseColor":
            
            self.definesPresentationContext = true
            
            var options = [ModalPickerOption]()
            for i in 0..<linkedProductsController.numberOfColors {
                let colorInfo = linkedProductsController.color(at: i)
                options.append((id: colorInfo.colorName, title: colorInfo.colorName, "", false))
            }
            
            let vc = segue.destination as! ModalPicker
            vc.options = options
            
            vc.onSelect = { [weak self] selectedOption in
                if selectedOption.id != self?.product.colorName,
                    let otherColorProduct = self?.linkedProductsController.sameProduct(withColorNamed: selectedOption.id) {
                    self?.dismiss(animated: true) {
                        self?.performSegueToOtherProduct(product: otherColorProduct)
                    }
                } else {
                    self?.dismiss(animated: true)
                }
            }
            
        default:
            break
        }
    }
    
    func performSegueToOtherProduct(product: ProductPresentation) {
        let storyboard = UIStoryboard(name: "Product", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        //vc.modalPresentationStyle = .fullScreen
        vc.product = product
        show(vc, sender: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        if let offer = offer {
            
        } else {
            performSegue(withIdentifier: "ChoseSize", sender: sender)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectColorButtonPressed(_ sender: Any) {
        if linkedProductsController.numberOfColors > 1 {
            performSegue(withIdentifier: "ChoseColor", sender: sender)
        }
    }
    
    @IBAction func selectSizeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "ChoseSize", sender: sender)
    }
    
}

// MARK: - UIScrollViewDelegate

extension ProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / imagesContainerView.bounds.width)
        pageControl.currentPage = currentPage
    }
}

// MARK: - UICollectionViewDataSource

extension ProductViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? linkedProductsController.numberOfRecommendedProducts : 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
    
        cell.configure(with: linkedProductsController.recomendedProduct(at: indexPath.item))
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegueToOtherProduct(product: linkedProductsController.recomendedProduct(at: indexPath.item))
        
    }
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)!.sectionInset
        let safeSize = collectionView.frame.inset(by: insets)
        
        if traitCollection.verticalSizeClass == .compact {
            return CGSize(width: (safeSize.width / 4) - 4,
                          height: safeSize.height)
        } else {
            return CGSize(width: (safeSize.width / 2) - 4,
                          height: (safeSize.height))
        }
        
    }
}
