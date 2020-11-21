//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Jae Paek on 11/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        Client.logout(completion: {response, error in
            if let error = error {
                self.showError(message: error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func pin(_ sender: UIBarButtonItem) {
        let informationViewController = self.storyboard!.instantiateViewController(withIdentifier: "LocationNavigationController") as! UINavigationController
        let informationView = informationViewController.viewControllers[0] as! InformationViewController
        informationView.previousView = self
        present(informationViewController, animated: true, completion: nil)
    }
    
    @objc func refreshLocations() {
        
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
        }
        
    }
    
    func showDownloadFailure(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Failed to Get Student Locations", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.show(alertVC, sender: nil)
        }
        
    }
}
