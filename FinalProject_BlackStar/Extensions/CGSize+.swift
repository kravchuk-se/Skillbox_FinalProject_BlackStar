//
//  CGSize+.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 08.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

extension CGSize {
    func scaled(by scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
}
