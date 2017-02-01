//
//  DotsViewController.swift
//  Path
//
//  Created by Christian Otkjær on 04/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Path
import Arithmetic
import Graphics

class DotsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        path = paths.first
    }
    
    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl?
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl)
    {
        path = paths.get(sender.selectedSegmentIndex)
        path?.lineWidth = 8
    }
    
    lazy var paths: [UIBezierPath] = { return self.createPaths() }()
    
    func createPaths() -> [UIBezierPath]
    {
        let bounds = (imageView?.bounds ?? view.bounds).insetBy(dx: 10, dy: 10)
        
        let radius = floor(min(bounds.width, bounds.height) / 2)
        
        let paths = [
            UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: -.pi/4, endAngle: 5 * .pi / 4, clockwise: true),
            UIBezierPath(heartCenteredAt: CGPoint.zero, radius: radius),
            UIBezierPath(convexRegularPolygonWithNumberOfSides: 7, center: CGPoint.zero, circumscribedCircleRadius: radius),
            UIBezierPath(convexRegularPolygonWithNumberOfSides: 3, center: CGPoint.zero, circumscribedCircleRadius: radius)
            ]
        
        return paths
    }
    
    
    var path : UIBezierPath?
    {
        didSet { updateImage() }
    }
    
    func updateImage()
    {
        //    let path = UIBezierPath()
        //    path.move(to: CGPoint(x: 10, y:10))
        //    path.addLine(to: CGPoint(x: 290, y: 10))
        
        imageView?.image = dottedImage()
    }
    
    func dottedImage() -> UIImage
    {
        guard let path = self.path else { return UIImage() }

        path.lineWidth = 8
        let frame = path.strokeBounds.integral
        
        let p = path.translated(tx: -frame.minX, ty: -frame.size.height - frame.minY).flippedVertically()
        p.lineWidth = 8
        let opaque = false
        
        UIGraphicsBeginImageContextWithOptions(frame.size, opaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        p.strokeWithDots()
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
