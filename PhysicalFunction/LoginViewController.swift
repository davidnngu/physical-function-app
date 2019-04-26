//
//  LoginViewController.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/21/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitle("LOG IN", for: .normal)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 5
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard
            let email = emailText.text,
            email != "",
            
            let password = passwordText.text,
            password != ""
            
            else {
                let confirmation = UIAlertController(title:"Error", message: "Please fill out all fields", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("OK button tapped")
                })
                
                confirmation.addAction(ok)
                self.present(confirmation, animated: true, completion: nil)
                return
        }
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            
            if(user != nil){
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            if (error != nil) {
                let incorrect = UIAlertController(title:"Error", message: "Password is incorrect", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("OK button tapped")
                })
                
                incorrect.addAction(ok)
                self.present(incorrect, animated: true, completion: nil)
                return
                
            }
        }
        
    }
}
