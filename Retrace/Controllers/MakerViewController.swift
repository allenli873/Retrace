//
//  MakerViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

class MakerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var imagePickerController: UIImagePickerController!
    var fileURLPath: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Image Taking and Saving
    @IBAction func onPhotoButton(_ sender: UIButton) {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
    @IBAction func onSaveButton(_ sender: UIButton) {
        saveImage(imageName: "test.png")
    }
    
    func saveImage(imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileManager = FileManager.default
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        fileURLPath = fileURL.path
        guard let data = imageView.image?.pngData() else { return }
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path, \(removeError)")
                return
            }
        }
        print(fileURL)
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
            return
        }
        
        performSegue(withIdentifier: K.SegueIdentifiers.customizerSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CustomizationViewController
        destinationVC.imagePath = fileURLPath
    }
}
