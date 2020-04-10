//
//  Constants.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

struct K {
    static let cellIdentifier = "swipeableCell"
    struct SegueIdentifiers {
        static let itemsSegue = "goToItems"
        static let makerSegue = "goToMaker"
        static let customizerSegue = "goToCustomizer"
        static let imageSegue = "goToImageView"
    }
    // persisted UserDefaults
    static let imageCountKey = "countKey"
    // documents directory
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
}
