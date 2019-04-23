//
//  SecondViewController.swift
//  Physical Function Application
//
//  Created by UNC Support on 2/28/19.
//  Copyright © 2019 COMP523. All rights reserved.
//

import UIKit
import FirebaseUI
import Firebase

class MenuViewController: UIViewController {

    @IBOutlet weak var buttonOne: UIButton!
    @IBOutlet weak var buttonTwo: UIButton!
//    @IBOutlet weak var buttonThree: UIButton!
    @IBOutlet weak var buttonFour: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOne.applyDesign()
        buttonTwo.applyDesign()
//        buttonThree.applyDesign()
        buttonFour.applyDesign()
    }
    
    
    @IBAction func logout(_ sender: UIButton) {
        let confirmation = UIAlertController(title:"Confirm", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "YES", style: .default, handler: { (action) -> Void in
            print("YES button tapped")
            self.logoutUser()
        })
        
        // Create Cancel button with action handlder
        let no = UIAlertAction(title: "NO", style: .cancel) { (action) -> Void in
            print("NO button tapped")
        }
        
        confirmation.addAction(no)
        confirmation.addAction(yes)
        self.present(confirmation, animated: true, completion: nil)
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            present(homeView, animated: true, completion: nil)
        }
        catch {
            print("error")
        }
    }
    
}

extension UIButton {
    func applyDesign() {
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 7
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
