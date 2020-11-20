//
//  ViewController.swift
//  On the Map
//
//  Created by Jae Paek on 4/19/20.
//  Copyright © 2020 Jae Paek. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameInput.text = ""
        passwordInput.text = ""
        activityIndicator.stopAnimating()
        usernameInput.isHidden = false
    }

    @IBAction func login(_ sender: Any) {
        Client.login(username: usernameInput.text ?? "", password: passwordInput.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        usernameInput.isEnabled = !loggingIn
        passwordInput.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            
            print(error?.localizedDescription)
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    
    
}

