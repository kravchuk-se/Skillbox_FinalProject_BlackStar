//
//  ProductViewModel.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 15.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import UIKit

struct ProductPresentation {
    
    let id: String
    let name: String
    let mainImage: String?
    let tag: String?
    let tagColor: UIColor
    let price: String
    let oldPrice: String?
    
    let description: String
    let colorName: String
    let colorImageURL: String?
    let productImageURLs: [String]
    let offers: [OfferPresentation]
    let recommendedProductIDs: [String]
    let attributes: [ProductAttributePresentation]
    
    func attributesText(headlineFont: UIFont, descriptionFont: UIFont) -> NSAttributedString? {
        
        guard attributes.count > 0 else {
            return nil
        }
        
        let result = attributes.reduce(NSMutableAttributedString()) { result, attribute in
            
                result.append(
                    NSAttributedString(string: attribute.name + ":", attributes:
                        [NSAttributedString.Key.font : headlineFont,
                         NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel]
                    )
                )
                result.append(
                    NSAttributedString(string: " " + attribute.value, attributes:
                        [NSAttributedString.Key.font : descriptionFont,
                         NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
                )
            
                result.append(NSAttributedString(string: "\n"))
            
            return result
        }
        
        return NSAttributedString(attributedString: result)
        
    }
    
    init(id: String, name: String, description: String, mainImage: String?, price: Double, tag: String?, colorName: String, colorImageURL: String?, productImageURLs: [String], offers: [OfferPresentation], recommendedProductIDs: [String], attributes: [ProductAttributePresentation]) {
        self.id = id
        self.name = name
        self.description = description
        self.mainImage = mainImage
    
        let discount: Double? = ProductPresentation.discount(forTag: tag)
        self.oldPrice = ProductPresentation.oldPriceFormatted(currentPrice: price, discount: discount)
        self.price = ProductPresentation.priceFormatted(price)
        
        self.tag = tag
        self.tagColor = ProductPresentation.tagColor(forTag: tag)
        
        self.colorName = colorName
        self.colorImageURL = colorImageURL
        self.productImageURLs = productImageURLs
        self.offers = offers
        self.recommendedProductIDs = recommendedProductIDs
        self.attributes = attributes
    }
    
    
    static func discount(forTag tag: String?) -> Double? {
        if let tag = tag {
            let discountString = tag.reduce("") { result, char in
                if let _ = Int(String(char)) {
                    return result + String(char)
                } else {
                    return result
                }
            }
            return Double(discountString)
        } else {
            return nil
        }
    }
    static func priceFormatted(_ price: Double) -> String {
        return priceFormatter.string(from: NSNumber(value: price))!
    }
    static func oldPriceFormatted(currentPrice: Double, discount: Double?) -> String? {
        if let discount = discount {
            let oldPriceValue = currentPrice * 100 / (100 - discount)
            return priceFormatter.string(from: NSNumber(value: oldPriceValue))
        } else {
            return nil
        }
    }
    static func tagColor(forTag tag: String?) -> UIColor {
        switch tag {
        case "new":
            return UIColor.systemRed
        case "", nil:
            return UIColor.clear
        default:
            return UIColor.systemGreen
        }
    }
    
    private static var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.currencySymbol = "₽"
        return formatter
    }()
    
}

struct OfferPresentation {
    let size: String
    let productOfferID: String
    let quantity: Int
}

struct ProductAttributePresentation {
    let name: String
    let value: String
}

extension ProductRealm {
    var presentation: ProductPresentation {
        let imageURLs = self.productImages.sorted(byKeyPath: "sortOrder").map {$0.imageURL}
        let allImages = [self.mainImage!] + imageURLs
        let offers: [OfferPresentation] = self.offers.map({ OfferPresentation(size: $0.size, productOfferID: $0.productOfferID, quantity: $0.quantity)})
        
        let attributes: [ProductAttributePresentation] = self.attributes.map { ProductAttributePresentation(name: $0.name, value: $0.value) }
        
        return ProductPresentation(
            id: self.id,
            name: self.name,
            description: productDescription,
            mainImage: self.mainImage,
            price: self.price,
            tag: self.tag,
            colorName: self.colorName,
            colorImageURL: self.colorImageURL,
            productImageURLs: allImages,
            offers: offers,
            recommendedProductIDs: recommendedProductIDs.map({$0}),
            attributes: attributes
        )
    }
}

