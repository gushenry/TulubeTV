//
//  LoginModel.swift
//  Tulube
//
//  Created by James Ormond on 11/6/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation

/**
 This class handles the logic for the LoginViewController.
 */
class LoginModel {
    
    /**
     Determines if a username if valid.
     
     - parameter username: The String to be validated.
     
     - returns: True if the *username* is valid, False otherwise
 */
    func isValidUsername(username: String) -> Bool {
        if username == "" {
            return false
        }
        UserDefaults.standard.setValue(username, forKey: "username")
        return true
    }
    
    /**
     Accesses UserDefaults for a saved username.
     
     - returns: An Optional String representing a saved username.
 */
    func getUsernameDefault() -> String? {
        return UserDefaults.standard.string(forKey: "username")
    }
    
}
