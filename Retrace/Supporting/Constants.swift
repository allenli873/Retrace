//
//  Constants.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

struct K {
    struct CellIdentifiers {
        static let categoryIdentifier = "categoryCell"
        static let itemIdentifier = "itemCell"
    }
    struct SegueIdentifiers {
        static let itemsSegue = "goToItems"
        static let makerSegue = "goToMaker"
        static let customizerSegue = "goToCustomizer"
        static let imageSegue = "goToImageView"
    }
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}
