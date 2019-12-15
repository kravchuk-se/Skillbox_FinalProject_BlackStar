//
//  CategoryCell.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    func configure(with category: Category ) {
        iconURL = category.image
        categoryNameLabel.text = category.name
    }
    
    func configure(with subcategory: Subcategory) {
        iconURL = subcategory.iconImage
        categoryNameLabel.text = subcategory.name
    }
    
    var iconURL: String? {
        didSet {
            self.activityIndicator.startAnimating()
            icon = nil
            let url = iconURL
            ImageProvider.loadImage(url: iconURL) { image  in
                if self.iconURL == url {
                    self.icon = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    var icon: UIImage? {
        get {
            iconView.image
        }
        set {
            self.iconView?.image = newValue
        }
    }
        
}
