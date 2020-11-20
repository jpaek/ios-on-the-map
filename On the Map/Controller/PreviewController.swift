//
//  PreviewController.swift
//  On the Map
//
//  Created by Jae Paek on 11/20/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit
import MapKit

class PreviewController: UIViewController {
    var location: StudentInformation!
    var previousView: UIViewController!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.addAnnotations([self.getAnnotation()])
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let lat = CLLocationDegrees(location.latitude)
        let lon = CLLocationDegrees(location.longitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let firstName = location.firstName
        let lastName = location.lastName
        let mediaURL = location.mediaURL
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    @IBAction func finish(_ sender: Any) {
        if Client.Location.objectId == "" {
            Client.setStudentInformation(location: location, completion: {(success, error) in
                if let error = error {
                    self.showError(message: error.localizedDescription)
                }
                
            })
        } else {
            self.location.objectId = Client.Location.objectId
            Client.updateStudentInformation(location: self.location, completion: {(success, error) in
                if let error = error {
                    self.showError(message: error.localizedDescription)
                }
            })
        }
        dismiss(animated: true, completion: {() in
            self.previousView.refreshLocations()
        })
    }
}
