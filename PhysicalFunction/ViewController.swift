//
//  ViewController.swift
//  PhysicalFunction
//  Created by David Nguyen on 2/27/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {

    @IBOutlet weak var button0: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button0.applyDesign()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            return
        }
    
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
}


extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        guard error == nil else {
            return
        }
        performSegue(withIdentifier: "goHome", sender: self)
    }
}



