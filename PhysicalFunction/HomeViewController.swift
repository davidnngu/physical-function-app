//
//  FirstViewController.swift
//  Physical Function Application
//
//  Created by UNC Support on 2/28/19.
//  Copyright © 2019 COMP523. All rights reserved.
//

import UIKit
import ResearchKit
import Firebase

class HomeViewController: UIViewController {
    //MARK: Properties

    var myString = String()

    let userID = Auth.auth().currentUser?.uid
    let email = Auth.auth().currentUser?.email
    
    
    @IBOutlet weak var PFScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pfScore: Double = 0.0
        let docref = Firestore.firestore().document("users/\(email ?? "0")")
        
        
        docref.getDocument{ (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {
                docref.setData(["PFScore": 0] as [String: Any])
                return
            }
            let myData = docSnapshot.data()
            pfScore = myData!["PFScore"] as? Double ?? 0
            self.PFScore.text = "\(pfScore)"
        }
                
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        var pfScore: Double = 0.0
        
        let docref = Firestore.firestore().document("users/\(email ?? "0")")
        docref.getDocument{ (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            pfScore = myData!["PFScore"] as? Double ?? 0
            self.PFScore.text = "\(pfScore)"
        }

    }

   
   
}

