//
//  Realm+.swift
//  FinalProject_BlackStar
//
//  Created by Kravchuk Sergey on 01.12.2019.
//  Copyright © 2019 Kravchuk Sergey. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static var main: Realm = {
        let rlm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return rlm
    }()
}
