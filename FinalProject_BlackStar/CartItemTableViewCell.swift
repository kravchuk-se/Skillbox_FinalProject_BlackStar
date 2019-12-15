//
//  OrderItemCell.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 30.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
}
