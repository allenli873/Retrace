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
    var incomingItem: Item? {
        didSet {
            // should definitely have an image name
            getImage(imageName: incomingItem!.imageName!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getImage(imageName: String) {
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            displayImage.image = UIImage(contentsOfFile: imagePath)
            displayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        } else {
            print("Error: no image found imageviewcontroller")
        }
    }
}
