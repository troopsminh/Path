//
//  ViewController.swift
//  PathDemo
//
//  Created by Christian Otkjær on 30/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Path

class ViewController: UIViewController
{
    @IBOutlet var pathLabel: PathLabel!
    
    override func viewWillAppear(animated: Bool)
    {
        let arc = UIBezierPath()
        arc.addArcWithCenter(CGPoint(100,100), radius: 100, startAngle: CGFloat.π_8, endAngle: CGFloat.π2, clockwise: true)
        
        
        
        pathLabel.path = arc
        
//        let line = UIBezierPath()
//        line.moveToPoint(CGPointZero)
//        line.addLineToPoint(CGPoint(300,0))
//        
//        pathLabel.path = line
        
        //UIBezierPath(ovalInRect: CGRect(size: CGSize(200,150)))
    }
}

