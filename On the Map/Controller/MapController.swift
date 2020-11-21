//
//  MapController.swift
//  On the Map
//
//  Created by Jae Paek on 11/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.addAnnotations(self.getAnnotations())
    }
    
    func getAnnotations() -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
        mapView.removeAnnotations(mapView.annotations)
        
        for student in StudentModel.students {
            annotations.append(getAnnotation(student))
        }
        return annotations
    }
    
    func getAnnotation(_ student: StudentInformation) -> MKPointAnnotation {
        let lat = CLLocationDegrees(student.latitude)
        let lon = CLLocationDegrees(student.longitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let firstName = student.firstName
        let lastName = student.lastName
        let mediaURL = student.mediaURL
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(firstName) \(lastName)"
        annotation.subtitle = mediaURL
        
        return annotation
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        refreshLocations()
    }
    
    override func refreshLocations() {
        _ = Client.getStudentInformation(completion: { students, error in
            if let error = error {
                self.showDownloadFailure(message: error.localizedDescription)
            } else {
                StudentModel.students = students
                self.mapView.addAnnotations(self.getAnnotations())
            }
            
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if toOpen != "" {
                    app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
}
