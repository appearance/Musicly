//
//  CurrentListID.swift
//  Musicly
//
//  Created by Christopher Webb-Orenstein on 4/23/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class CurrentListID: Object {
    dynamic var id: String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}

