//
//  UIBezierPath+Polygon.swift
//  Polygon
//
//  Created by Christian Otkjær on 16/11/16.
//  Copyright © 2016 Silverback IT. All rights reserved.
//

import Arithmetic
import Graphics

public extension UIBezierPath
{
        public convenience init(
            polygonWithCorners corners: [CGPoint])
        {
            self.init()
    
            guard corners.count > 2 else { debugPrint("A polygon must have at least three corners, not \(corners.count)"); return }
    
            move(to: corners[0])
    
            for corner in corners[1..<corners.endIndex]
            {
                addLine(to: corner)
            }
    
            close()
        }
    
        public convenience init(polygonWithCorners corners: CGPoint...)
        {
            self.init(polygonWithCorners: corners)
        }
    
        /**
         Initializeses the bezier curve as a N-Sided Convex Regular Polygon
    
         - parameter n: number of sides
         - parameter center: center og the polygon. Default is (0,0)
         - parameter radius: the radius of the circumscribed circle
         - parameter turned: if *true* the polygon is rotated (counterclockwise around center) to let the rightmost edge be vertical. If *false* the rightmost corner is directly right of the center. Default is *false*
         */
        public convenience init(
            convexRegularPolygonWithNumberOfSides n: Int,
            center: CGPoint = CGPoint.zero,
            circumscribedCircleRadius radius: CGFloat,
            turned: Bool = false)
        {
            precondition(n > 2, "A polygon must have at least three sides")
    
            self.init()
    
            move(to: CGPoint(x: radius, y: 0))
    
            for theta in (1 ..< n).map({ $0 * 2 * π / n } )
            {
                addLine(to: CGPoint(x: radius * cos(theta), y: radius * sin(theta)))
            }
    
            close()
    
            if turned
            {
                apply(CGAffineTransform(rotationAngle: π_2 - π / n))
    
                //            applyTransform(CGAffineTransformMakeRotation(π / CGFloat(n)))
            }
    
            apply(CGAffineTransform(translationX: center.x, y: center.y))
        }
    
        public convenience init(pentagonWithCenter center: CGPoint = CGPoint.zero, sideLength: CGFloat, turned: Bool = false)
        {
            self.init(convexRegularPolygonWithNumberOfSides: 5, center: center, circumscribedCircleRadius: sideLength, turned: turned)
        }
}
//import Arithmetic
//import Graphics
//
//// MARK: - Polygon
//
//extension UIBezierPath
//{
//    public convenience init(polygonWithCorners corners: CGPoint...)
//    {
//        self.init()
//        
//        guard corners.count > 2 else { debugPrint("A polygon must hav at least 3 sides"); return }
//
//        var cs = corners
//        
//        move(to: cs.removeFirst())
//        
//        for c in cs
//        {
//            addLine(to: c)
//        }
//        
//        close()
//    }
//}
