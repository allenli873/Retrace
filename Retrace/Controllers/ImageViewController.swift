//
//  ImageViewController.swift
//  Retrace
//
//  Created by Allen Li on 4/3/20.
//  Copyright © 2020 Allen Li. All rights reserved.
//

import UIKit
import MapKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var displayImage: UIImageView!
    @IBOutlet weak var locationMapView: MKMapView!
    var incomingItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let item = incomingItem else {
            fatalError("incomingItem is nil")
        }
        let locValue = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
        
        locationMapView.mapType = MKMapType.standard
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        print("\(item.latitude), \(item.longitude)")
        let region = MKCoordinateRegion(center: locValue, span: span)
        locationMapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = item.name
        locationMapView.addAnnotation(annotation)
        
        getImage(with: incomingItem!.imageName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = incomingItem?.name
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
