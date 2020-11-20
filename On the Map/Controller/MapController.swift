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
        
        _ = Client.getStudentInformation(completion: { students, error in
            if let error = error {
                self.showDownloadFailure(message: error.localizedDescription)
            } else {
                StudentModel.students = students
                self.mapView.addAnnotations(self.getAnnotations())
            }
            
        })
    }
    
    @IBAction func pin(_ sender: UIBarButtonItem) {
        let informationViewController = self.storyboard!.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
        
        navigationController!.pushViewController(informationViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.addAnnotations(self.getAnnotations())
    }
    
    func getAnnotations() -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = [MKPointAnnotation]()
        
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
    
    func showDownloadFailure(message: String) {
        let alertVC = UIAlertController(title: "Failed to Get Student Locations", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
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
