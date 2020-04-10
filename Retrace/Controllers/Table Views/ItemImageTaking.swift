//
//  MakerViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit

extension ItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Image Taking
    
    func photoTaking() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePickerController.dismiss(animated: true, completion: nil)
        saveImage(with: info[UIImagePickerController.InfoKey.originalImage] as? UIImage)
    }
    
    //MARK: - Image Saving
    
    func saveImage(with image: UIImage?) {
        let currImageCount = defaults.integer(forKey: K.imageCountKey)
        let imageName = "image_\(currImageCount).jpeg"
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileManager = FileManager.default
        let fileURL = documentsDirectory.appendingPathComponent(imageName)
        guard let data = image?.jpegData(compressionQuality: 1.0) else { return }
        
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
    func prepareCustomizerVC(for segue: UIStoryboardSegue, _ sender: Any?) {
        let destinationVC = segue.destination as! CustomizationViewController
        let currImageCount = defaults.integer(forKey: K.imageCountKey)
        destinationVC.imageName = "image_\(currImageCount).jpeg"
        defaults.set(currImageCount + 1, forKey: K.imageCountKey)
    }
    
}
