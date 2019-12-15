//
//  Category.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation

struct CategoryJSON: Codable {
    var id:              String = ""
    let name:            String
    let sortOrder:       Int
    let image:           String?
    let iconImage:       String?
    let iconImageActive: String?
    
    let subcategories: [SubcategoryJSON]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
        
        image           = try? container.decode(String.self, forKey: .image)
        iconImage       = try? container.decode(String.self, forKey: .iconImage)
        iconImageActive = try? container.decode(String.self, forKey: .iconImageActive)
        
        subcategories = try  container.decode([SubcategoryJSON].self, forKey: .subcategories).sorted { $0.sortOrder < $1.sortOrder }
        
    }
    
    
    private enum CodingKeys: String, CodingKey {
        
        case name
        case sortOrder
        case image
        case iconImage
        case iconImageActive
        case subcategories
    }
    
}
