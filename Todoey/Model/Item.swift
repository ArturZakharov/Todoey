//
//  Item.swift
//  Todoey
//
//  Created by ArturZaharov on 21.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var done:Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property:  "items")
}
