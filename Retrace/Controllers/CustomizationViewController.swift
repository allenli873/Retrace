//
//  CustomizationViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import RealmSwift
import CoreLocation

class CustomizationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    let locationManager = CLLocationManager()
    var imageName: String!
    var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
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
            fatalError("Error: could not go back to item view")
        }
        let newItem = Item()
        newItem.name = textField.text!
        newItem.imageName = imageName
        
        if currentLocation == nil {
            let alert = UIAlertController(title: "Still fetching location", message: "Continue Anyway?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
                itemVC.incomingItem = newItem
                self.navigationController?.popToViewController(itemVC, animated: true)
            }
            let cancel = UIAlertAction(title: "Wait", style: .default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            newItem.latitude = currentLocation!.coordinate.latitude
            newItem.longitude = currentLocation!.coordinate.longitude
            itemVC.incomingItem = newItem
            self.navigationController?.popToViewController(itemVC, animated: true)
        }
    }
}

extension CustomizationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            currentLocation = location
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
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
