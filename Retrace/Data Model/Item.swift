//
//  Item.swift
//  Retrace
//
//  Created by Allen Li on 4/8/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var imageName: String = ""
    @objc dynamic var name: String = ""
    // defaults to somewhere random in San Francisco
    @objc dynamic var latitude: Double = 37.0
    @objc dynamic var longitude: Double = -122.0
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
