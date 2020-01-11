//
//  CGRect+.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 11.01.2020.
//  Copyright © 2020 Kravchuk Sergey. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
