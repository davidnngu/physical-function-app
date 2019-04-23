//
//  FirstViewController.swift
//  Physical Function Application
//
//  Created by UNC Support on 2/28/19.
//  Copyright © 2019 COMP523. All rights reserved.
//

import UIKit
import ResearchKit

class HomeViewController: UIViewController {
    //MARK: Properties

    var myString = String()
    @IBOutlet weak var PFScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabbar = tabBarController as! DataController
        PFScore.text = String(describing: tabbar.valuePFScore)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tabbar = tabBarController as! DataController
        PFScore.text = String(describing: tabbar.valuePFScore)
    }

   
   
}

