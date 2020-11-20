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
    
    func showError(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
