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
    var imageName: String!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if defaults.object(forKey: K.imageCountKey) == nil {
            defaults.set(0, forKey: K.imageCountKey)
        }
    }
    
    //MARK: - Image Taking
    
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
    
    //MARK: - Image Saving
    
    @IBAction func onSaveButton(_ sender: UIButton) {
        let currImageCount = defaults.integer(forKey: K.imageCountKey)
        imageName = "image_\(currImageCount).png"
        saveImage(with: imageName)
        defaults.set(currImageCount + 1, forKey: K.imageCountKey)
    }
    
    func saveImage(with imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileManager = FileManager.default
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        guard let data = imageView.image?.pngData() else { return }
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                try fileManager.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("couldn't remove file at path, \(removeError)")
                return
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("Error saving file, \(error)")
            return
        }
        
        performSegue(withIdentifier: K.SegueIdentifiers.customizerSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CustomizationViewController
        destinationVC.imageName = imageName
    }
}
