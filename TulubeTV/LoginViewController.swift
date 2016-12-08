//
//  LoginViewController.swift
//  Tulube
//
//  Created by James Ormond on 11/6/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import UIKit

/**
 Represents the UIViewController for the Login process.
 */
class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameMessageLabel: UILabel!
    
    let loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let username = self.loginModel.getUsernameDefault() {
            self.usernameTextField.text = username
        }
        
        self.usernameMessageLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        let username = self.usernameTextField.text!
        if self.loginModel.isValidUsername(username: username) {
            performSegue(withIdentifier: "loginToDrawSegue", sender: nil)
        } else {
            self.usernameMessageLabel.text = "Please enter a username"
        }
    }
  
}
