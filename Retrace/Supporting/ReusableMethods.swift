//
//  ReusableMethods.swift
//  Retrace
//
//  Created by Allen Li on 4/4/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

struct R {
    // method to get the file path in Documents to an image
    static func getFilePath(with imageName: String) -> String {
        guard let documentsDirectory = K.documentsDirectory else {
            print("Error: cannot find documents directory")
            return ""
        }
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        return fileURL.path
    }
}
