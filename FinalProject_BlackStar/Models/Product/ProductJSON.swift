//
//  Product.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//
import Foundation

struct ProductJSON: Codable {
    
    var id: String?
    let name: String
    let englishName: String
    let sortOrder: Int            //
    let article: String
    let description: String
    let colorName: String
    let colorImageURL: String?
    let mainImage: String?

    let productImages: [ProductImageJSON]
    let offers: [OfferJSON]
    let recommendedProductIDs: [String]?

    let price: Double             //
    let tag: String?

    let attributes: [[String: String]]?
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name          = try container.decode(String.self, forKey: .name)
        englishName   = try container.decode(String.self, forKey: .englishName)
        
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
        
        article       = try container.decode(String.self, forKey: .article)
        description   = try container.decode(String.self, forKey: .description)
        colorName     = try container.decode(String.self, forKey: .colorName)
        colorImageURL = try container.decode(String.self, forKey: .colorImageURL)
        mainImage     = try container.decode(String.self, forKey: .mainImage)
        productImages = try container.decode([ProductImageJSON].self, forKey: .productImages)
        offers        = try container.decode([OfferJSON].self, forKey: .offers)
        recommendedProductIDs = try? container.decode([String].self, forKey: .recommendedProductIDs)
        
        let priceString = try container.decode(String.self, forKey: .price)
        
        price = Double(exactly: Self.formatter.number(from: priceString) ?? 0)!
        
        tag = try? container.decode(String.self, forKey: .tag)
        attributes = try? container.decode([[String: String]].self, forKey: .attributes)
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
        case englishName
        case sortOrder
        case article
        case description
        case colorName
        case colorImageURL
        case mainImage
        case productImages
        case offers
        case recommendedProductIDs
        case price
        case tag
        case attributes
    }
    private static let formatter: NumberFormatter = {
        let fmtr = NumberFormatter()
        fmtr.locale = Locale(identifier: "en_EN")
        return fmtr
    }()
}

struct ProductImageJSON: Codable {
    let imageURL: String
    let sortOrder: Int
    
    init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        imageURL = try container.decode(String.self, forKey: .imageURL)
        
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case imageURL
        case sortOrder
    }
}

struct OfferJSON: Codable {
    let size: String
    let productOfferID: String
    let quantity: Int
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        size = try container.decode(String.self, forKey: .size)
        productOfferID = try container.decode(String.self, forKey: .productOfferID)
        
        if let quantityString = try? container.decode(String.self, forKey: .quantity) {
            quantity = Int(quantityString)!
        } else {
            quantity = try container.decode(Int.self, forKey: .quantity)
        }
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case size
        case productOfferID
        case quantity
    }
}
