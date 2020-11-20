//
//  InformationViewController.swift
//  On the Map
//
//  Created by Jae Paek on 11/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit
import MapKit

class InformationViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var errorMessage: UILabel!
    
    var previousView: UIViewController!
    
    override func viewDidLoad() {
        spinner.isHidden = true
        errorMessage.text = ""
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        errorMessage.text = ""
        spinner.isHidden = false
        if location.text?.isEmpty ?? false || url.text?.isEmpty ?? false {
            errorMessage.text = "Please provide the location and the link"
            spinner.isHidden = true
            return
        }
        
        if let parsedURL = URL(string: url.text ?? "") {
            if UIApplication.shared.canOpenURL(parsedURL) {
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = location.text
                let geocoder = MKLocalSearch(request: searchRequest)
                geocoder.start(completionHandler: { (response, error) in
                    guard let response = response else {
                        self.spinner.isHidden = true
                        self.errorMessage.text = "No location found"
                        return
                    }
                    
                    if let error = error {
                        self.spinner.isHidden = true
                        self.errorMessage.text =  error.localizedDescription
                        return
                    }
                    self.handleSelectedLocation(response)
                })
            }
            else {
                errorMessage.text =  "Invalid URL"
                spinner.isHidden = true
                return
            }
        } else {
            errorMessage.text = "Invalid URL"
            spinner.isHidden = true
            return
        }
    }
    
    func handleSelectedLocation(_ response: MKLocalSearch.Response) {
        let coordinates: CLLocation
        for item in response.mapItems {
            if let location_found = item.placemark.location {
                print(item)
                coordinates = location_found
                var studentLocation = Client.createLocationObject(latitude: coordinates.coordinate.latitude, longitude: coordinates.coordinate.longitude, location: self.location.text ?? "", url: self.url.text ?? "")
                print(studentLocation)
                navigateToPreview(studentLocation)
                self.spinner.isHidden = true
                self.errorMessage.text = ""
                break
            }
        }
    }
    
    func navigateToPreview(_ studentLocation: StudentInformation) {
        let previewController = self.storyboard!.instantiateViewController(withIdentifier: "PreviewController") as! PreviewController
        previewController.location = studentLocation
        previewController.previousView = previousView
        //present(previewController, animated: true, completion: nil)
        self.navigationController!.pushViewController(previewController, animated: true)
    }
    
}
