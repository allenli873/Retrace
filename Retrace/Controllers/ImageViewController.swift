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
    @IBOutlet weak var itemLabel: UILabel!
    var incomingItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = incomingItem?.name
        getImage(with: incomingItem!.imageName)
    }
    
    //MARK: - Image Loading
    
    func getImage(with imageName: String) {
        let fileManager = FileManager.default
        let path = R.getFilePath(with: imageName)
        if path.count == 0 {
            return
        }
        if fileManager.fileExists(atPath: path) {
            displayImage.image = UIImage(contentsOfFile: path)
        } else {
            print("Error: no image found")
        }
    }
}
