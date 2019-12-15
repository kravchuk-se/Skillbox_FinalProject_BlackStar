//
//  ImageProvider.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 24.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import UIKit
struct ImageProvider {
    
    static func loadImage(url imageURL: String?, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = imageURL, !imageURL.isEmpty else {
            completion(nil)
            return
        }
        let url = URL(string: "https://blackstarshop.ru/")!.appendingPathComponent(imageURL)
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    print("no image data")
                    completion(nil)
                }
            }
            if let error = error {
                print(error)
            }
        }.resume()
    }
    
}
