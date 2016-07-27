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
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewWillAppear(animated: Bool)
    {
        let arc = UIBezierPath()
        arc.addArcWithCenter(CGPoint(100,100), radius: 100, startAngle: CGFloat.π_8, endAngle: CGFloat.π2, clockwise: true)
        
        
        
        pathLabel.path = arc
        
        
        imageView.image = UIBezierPath(bezierPathWithHeartAtCenter: imageView.bounds.center, radius: imageView.bounds.width/2).image(strokeColor: UIColor.blackColor(), fillColor: UIColor.redColor().colorWithAlphaComponent(0.5), backgroundColor: nil)
        
//        let line = UIBezierPath()
//        line.moveToPoint(CGPointZero)
//        line.addLineToPoint(CGPoint(300,0))
//        
//        pathLabel.path = line
        
        //UIBezierPath(ovalInRect: CGRect(size: CGSize(200,150)))
    }
}

