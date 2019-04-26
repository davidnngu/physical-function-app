//
//  LoginSuccessController.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 3/21/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class LoginSuccessController: UIViewController {
    
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var userEmail: UILabel!
    override func viewDidLoad(){
        super.viewDidLoad()
        guard let email = Auth.auth().currentUser?.email
            else {
                return
        }
        userEmail.text = email
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        
        let docref = Firestore.firestore().document("users/\(email ?? "0")")
        
        
    }
 
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let mainTabController = storyboard?.instantiateViewController(withIdentifier: "DataController") as! DataController
        mainTabController.selectedViewController = mainTabController.viewControllers?[2]
        present(mainTabController, animated: true, completion: nil)
    }
    
}
