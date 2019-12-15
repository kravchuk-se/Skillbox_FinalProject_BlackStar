//
//  BatchUpdate.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 30.11.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//



enum BatchUpdate {
    case initial
    case update(deletions: [Int], insertions: [Int], modifications: [Int])
    case error(_: Error)
}
