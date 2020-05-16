//
//  ToDoItem.swift
//  Todoey
//
//  Created by ArturZaharov on 16.05.2020.
//  Copyright © 2020 ArturZaharov. All rights reserved.
//

import Foundation

class ToDoItem: Codable {
    var toDOTitel: String?
    var done: Bool = false
    
    init(titel: String) {
        self.toDOTitel = titel
    }
}
