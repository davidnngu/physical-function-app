//
//  CircleView.swift
//  PhysicalFunction
//
//  Created by David Nguyen on 4/10/19.
//  Copyright © 2019 David Nguyen. All rights reserved.
//

import UIKit

@IBDesignable
class CircleView: UIView {

    @IBInspectable var fillColor: UIColor = UIColor.gray
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
     */
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
    }
    

}
