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
        getImage(with: incomingItem.imageName!)
    }
    
    func getImage(with imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileManager = FileManager.default
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: fileURL.path) {
            displayImage.image = UIImage(contentsOfFile: fileURL.path)
            displayImage.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        } else {
            print("Error: no image found imageviewcontroller")
        }
    }
}
