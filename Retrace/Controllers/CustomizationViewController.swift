//
//  CustomizationViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import RealmSwift

class CustomizationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var imageName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        getImage(with: imageName)
    }
    
    //MARK: - Retrieving Image
    
    func getImage(with imageName: String) {
        let fileManager = FileManager.default
        let path = R.getFilePath(with: imageName)
        if path.count == 0 {
            return
        }
        if fileManager.fileExists(atPath: path) {
            imageView.image = UIImage(contentsOfFile: path)
        } else {
            print("Error: no image found")
        }
    }
    
    //MARK: - Save Button Pressed
    
    @IBAction func saveItemPressed(_ sender: UIButton) {
        if textField.text?.count == 0 {
            return
        }
        // second item on the stack: ItemViewController
        guard let itemVC = self.navigationController?.viewControllers[1] as? ItemViewController else {
            print("Error: could not go back to item view")
            return
        }
        
        let newItem = Item()
        newItem.name = textField.text!
        newItem.imageName = imageName
        itemVC.incomingItem = newItem
        navigationController?.popToViewController(itemVC, animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension CustomizationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        return true
    }
}
