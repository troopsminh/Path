//
//  ViewController.swift
//  PathDemo
//
//  Created by Christian Otkjær on 30/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Path
import Graphics

class ViewController: UIViewController
{
    @IBOutlet var pathLabel: PathLabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewWillAppear(_ animated: Bool)
    {
        let arc = UIBezierPath()
        arc.addArc(withCenter: CGPoint(100,100), radius: 100, startAngle: CGFloat.π_8, endAngle: CGFloat.π2, clockwise: true)
        
        pathLabel.path = arc
        
        let lineWidth : CGFloat = 20
        
        let imagePath = UIBezierPath(heartInRect: imageView.bounds.insetBy(dx: lineWidth, dy: lineWidth))
        
//        let imagePath = UIBezierPath(heartCenteredAt: imageView.bounds.center, radius: imageView.bounds.width/2)
        
        imagePath.lineWidth = lineWidth
        
        imageView.image = imagePath.image(strokeColor: UIColor.black, fillColor: UIColor.red.withAlphaComponent(0.5), backgroundColor: nil)
    }
}

