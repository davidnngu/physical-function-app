//
//  ChangePasswordController.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/10/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class ChangePasswordController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var button: UIButton!
    
    var oldPassword: String?
    var password: String?
    var confirmPassword: String?
    
    @IBAction func password(_ sender: UITextField) {
        password = sender.text
    }

    @IBAction func oldPassword(_ sender: UITextField) {
        oldPassword = sender.text
    }
    
    @IBAction func confirmPassword(_ sender: UITextField) {
        confirmPassword = sender.text
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if password != confirmPassword {
            createAlert(title: "Error", message: "Passwords do not match")
        } else {
            let user = Auth.auth().currentUser
            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPassword!)
//            do {
//                try Auth.auth().signOut()
//            }
//            catch {
//                print("error")
//            }
            user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
                if error != nil {
                    self.createAlert(title: "Error", message: "failed")
                }else{
                    Auth.auth().currentUser?.updatePassword(to: self.password!) { (error) in
                        print("Error")
                    }
                    self.createAlert(title: "Success", message: "Password change successful!")
                }
            })
        }
    }


}
