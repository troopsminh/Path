//
//  DragViewController.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Path

class DragViewController: UIViewController
{
    @IBOutlet var pathLabel: PathLabel?
    
    override func viewWillAppear(_ animated: Bool)
    {
        pathLabel?.text = String(number)
        
//        let arc = UIBezierPath()
//        arc.addArc(withCenter: CGPoint(100,100), radius: 100, startAngle: CGFloat.π_8, endAngle: CGFloat.π2, clockwise: true)
//        
//        pathLabel?.path = arc
    }
    
    var number = 1
    
    @IBAction func handle(_ sender: UITapGestureRecognizer)
    {
        guard sender.state == .ended else { return }
        
        number += sender.location(in: view).y > view.bounds.midY ? -1 : 1
        
        pathLabel?.animateText(to: String(number), duration: 0.25)
//        pathLabel?.text = String(number)
        
    }
    
}
