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
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isEnabled = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
        
        resetButton.layer.cornerRadius = 5.0
        resetButton.layer.masksToBounds = true
        resetButton.isEnabled = false
        resetButton.alpha = 0.5
        
        startButton.layer.cornerRadius = startButton.bounds.width / 2.0
        startButton.layer.masksToBounds = true
        
        pauseButton.layer.cornerRadius = pauseButton.bounds.width / 2.0
        pauseButton.layer.masksToBounds = true
        pauseButton.isEnabled = false
        pauseButton.alpha = 0.5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startDidTap(_ sender: UIButton) {
        if !isTimerRunning {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            
            resetButton.isEnabled = true
            pauseButton.isEnabled = true
            startButton.isEnabled = false
            
            resetButton.alpha = 1.0
            startButton.alpha = 0.5
            pauseButton.alpha = 1.0
        }
    }
    
    @IBAction func resetDidTap(_ sender: UIButton) {
        timer.invalidate()
        isTimerRunning = false
        counter = 0.0
        
        resetButton.alpha = 0.5
        startButton.alpha = 1.0
        pauseButton.alpha = 0.5
        print("test")
        timerLabel.text = "00:00:00.0"
        resetButton.isEnabled = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    
    
    
    @IBAction func pauseDidTap(_ sender: UIButton) {
        resetButton.isEnabled = true
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        resetButton.alpha = 1.0
        startButton.alpha = 1.0
        pauseButton.alpha = 0.5
        
        isTimerRunning = false
        timer.invalidate()
    
    }
    
    @objc func runTimer() {
        counter += 0.1
        
        let flooredCounter = Int(floor(counter))
        let hour = flooredCounter / 3600
        var hourString = "\(hour)"
        if hour < 10 {
            hourString = "0\(hour)"
        }
        let minute = (flooredCounter % 3600) / 60
        var minuteString  = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }
        let decisecond = String(format: "%.1f",
                                counter).components(separatedBy: ".").last!
        timerLabel.text = "\(hourString):\(minuteString):\(secondString).\(decisecond)"
        
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
