//
//  ProductCell.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 26.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagView: TagView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    func configure(with product: ProductPresentation) {
        imageURL = product.mainImage
        tagView.tagText = product.tag
        productNameLabel.text = product.name
        
        tagView.tagColor = product.tagColor
        priceLabel.text = product.price
        
        if let oldPrice = product.oldPrice {
            oldPriceLabel.isHidden = false
            oldPriceLabel.text = oldPrice
            priceLabel.textColor = .systemRed
        } else {
            oldPriceLabel.isHidden = true
            oldPriceLabel.text = nil
            priceLabel.textColor = .label
        }
    }
    
    var imageURL: String? {
        didSet {
            self.activityIndicator.startAnimating()
            productImageView.image = nil
            let url = imageURL
            ImageProvider.loadImage(url: imageURL) { image  in
                if self.imageURL == url {
                    self.productImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    static let reuseIdentifier = "ProductCell"
    static let nibName = "ProductCollectionViewCell"
    
}
