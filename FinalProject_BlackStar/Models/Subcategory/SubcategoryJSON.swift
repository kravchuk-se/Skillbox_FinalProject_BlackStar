//
//  Subcategory.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation

struct SubcategoryJSON: Codable {
    let id:        String
    let iconImage: String
    let sortOrder: Int
    let name:      String
    let type:      String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = "\(idInt)"
        } else {
            id = try container.decode(String.self, forKey: .id)
        }
        
        iconImage = try container.decode(String.self, forKey: .iconImage)
        
        if let sortOrderString = try? container.decode(String.self, forKey: .sortOrder) {
            sortOrder = Int(sortOrderString)!
        } else {
            sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        }
        name = try container.decode(String.self, forKey: .name)
        
        type = try? container.decode(String.self, forKey: .type)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case iconImage
        case sortOrder
        case name
        case type
    }
    
}
