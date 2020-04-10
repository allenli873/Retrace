//
//  Category.swift
//  Retrace
//
//  Created by Allen Li on 4/8/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var hexValue: String = ""
    let items = List<Item>()
}
