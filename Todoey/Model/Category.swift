//
//  Category.swift
//  Todoey
//
//  Created by ArturZaharov on 21.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
