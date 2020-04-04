//
//  CustomizationViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

class CustomizationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        getImage(with: imageName)
    }
    
    func getImage(with imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileManager = FileManager.default
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: fileURL.path) {
            imageView.image = UIImage(contentsOfFile: fileURL.path)
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2))
        } else {
            print("Error: no image found")
        }
    }
    @IBAction func saveItemPressed(_ sender: UIButton) {
        if textField.text?.count == 0 {
            return
        }
        // second item on the stack: ItemViewController
        guard let itemVC = self.navigationController?.viewControllers[1] as? ItemViewController else {
            print("Error: could not go back to item view")
            return
        }
        
        let newItem = Item(context: K.context)
        newItem.name = textField.text!
        newItem.imageName = imageName
        itemVC.incomingItem = newItem
        navigationController?.popToViewController(itemVC, animated: true)
    }
}

extension CustomizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        return true
    }
}
