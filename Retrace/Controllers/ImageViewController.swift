//
//  ImageViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var displayImage: UIImageView!
    var incomingItem: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage(imagePath: incomingItem.imagePath!)
    }
    
    func getImage(imagePath: String) {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: imagePath) {
            displayImage.image = UIImage(contentsOfFile: imagePath)
            displayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        } else {
            print("Error: no image found imageviewcontroller")
        }
    }
}
