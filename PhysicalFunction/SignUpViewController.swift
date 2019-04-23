//
//  SignUpViewController.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/21/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func pressedSignUp(_ sender: Any) {
        guard
        let email = emailText.text,
        email != "",
        
        let password = passwordText.text,
        password != ""
        
        else {
            let confirmation = UIAlertController(title:"Error", message: "Please fill out all fields", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("YES button tapped")
            })
            
            confirmation.addAction(ok)
            self.present(confirmation, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) {
            (user, error) in
            
            if(user != nil){
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            }
            if (error != nil) {
                print("error")
            }
        }
    }
}
