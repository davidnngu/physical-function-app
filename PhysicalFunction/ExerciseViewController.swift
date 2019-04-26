//
//  FifthViewController.swift
//  Physical Function Application
//
//  Created by UNC Support on 2/28/19.
//  Copyright © 2019 COMP523. All rights reserved.
//

import UIKit
import Firebase

class ExerciseViewController: UITableViewController {

    var initHeart: String?
    var distance: String?
    var time: String?
    var endHeart: String?
    
    let email = Auth.auth().currentUser?.email
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func initialHeartRate(_ sender: UITextField) {
        initHeart = sender.text
        
    }
    
    @IBAction func distanceWalked(_ sender: UITextField) {
        distance = sender.text
    }
    
    @IBAction func totalTime(_ sender: UITextField) {
        time = sender.text
    }
    
    @IBAction func endHeart(_ sender: UITextField) {
        endHeart = sender.text

    }
    @IBAction func inputData(_ sender: UIButton) {
        let exerciseData = [initHeart, distance, time, endHeart]
        let docref = Firestore.firestore().document("users/\(email ?? "0")")
        let newref = docref.collection("Exercise Tests").document("\(date)")
        let dataToSave = ["Exercise Test Data": exerciseData]
        newref.setData(dataToSave)
        let success = UIAlertController(title:"SUCCESS", message: "Data has been inputted", preferredStyle: .alert)
        
        // Create Cancel button with action handlder
        let worked = UIAlertAction(title: "OK", style: .cancel) { (action) -> Void in
            print("works!")
        }
        
        success.addAction(worked)
        self.present(success, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
