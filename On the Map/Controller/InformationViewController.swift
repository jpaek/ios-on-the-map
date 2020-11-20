//
//  InformationViewController.swift
//  On the Map
//
//  Created by Jae Paek on 11/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit
import MapKit

class InformationViewController: UIViewController {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        spinner.isHidden = true
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location.text
        let geocoder = MKLocalSearch(request: searchRequest)
        spinner.isHidden = false
        geocoder.start(completionHandler: { (response, error) in
            guard let response = response else {
                return
            }
            let coordinates: CLLocation
            for item in response.mapItems {
                if let location_found = item.placemark.location {
                    print(item)
                    coordinates = location_found
                    var studentLocation = Client.createLocationObject(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude, location: self.location.text ?? "", url: self.url.text ?? "")
                    print(studentLocation)
                    if Client.Location.objectId == "" {
                        Client.setStudentInformation(location: studentLocation, completion: {(success, error) in
                            if let error = error {
                                print(error)
                            }
                            self.spinner.isHidden = true
                            studentLocation.objectId = Client.Location.objectId
                            StudentModel.students.insert(studentLocation, at: 0)
                            self.openMapView()
                            
                        })
                    } else {
                        studentLocation.objectId = Client.Location.objectId
                        Client.updateStudentInformation(location: studentLocation, completion: {(success, error) in
                            self.spinner.isHidden = true
                            studentLocation.objectId = Client.Location.objectId
                            StudentModel.students.insert(studentLocation, at: 0)
                            self.openMapView()
                        })
                    }
                    break
                }
            }

        })
    }
    
    func openMapView() {
        let mapViewController = self.storyboard!.instantiateViewController(withIdentifier: "MapController") as! MapController
        navigationController!.pushViewController(mapViewController, animated: true)
    }
    
}
