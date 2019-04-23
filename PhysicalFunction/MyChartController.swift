//
//  MyChartController.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/9/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import UIKit


class MyChartController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openURL(_ sender: UIButton) {
                openUrl(urlStr: "https://myuncchart.org/mychart/")
    }
    
    func openUrl(urlStr:String!) {
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
}
