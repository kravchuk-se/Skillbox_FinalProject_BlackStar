//
//  BlackStarAPI.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 22.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation

struct BlackStarAPI {
    
    enum Endpoint {
        case categories
        case products(subcategoryID: String)
    }
    
    enum Result<T> {
        case success(value: T)
        case fail(error: Error)
    }
    
    enum BSError: Error {
        case unknown
    }
    
    static func fetch<T: Codable>(_ endpoint: Endpoint, completion: @escaping ((Result<T>) -> Void) ) {
        
        let url: URL
        
        switch endpoint {
        case .categories:
            url = categoriesURL
        case .products(let subcategoryID):
            url = productsURL(forSubcategoryID: subcategoryID)
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data,
                let parsedData = try? JSONDecoder().decode(T.self, from: data) {
                
                completion(.success(value: parsedData))
                
            } else if let error = error {
                
                completion(.fail(error: error))
                
            } else {
                
                completion(.fail(error: BSError.unknown))
                
            }
            
        }.resume()
    }
    
    private static let categoriesURL = URL(string: "http://blackstarshop.ru/index.php?route=api/v1/categories")!
    private static func productsURL(forSubcategoryID subcategoryID: String) -> URL {
        return URL(string: "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(subcategoryID)")!
    }
}
