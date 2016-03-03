//
//  Drop.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics

extension UIBezierPath
{
    public convenience init(dropWithCenter center: CGPoint, radius: CGFloat)
    {
        self.init()
        
        let topPoint = CGPoint(x: 0, y: radius * 2)
        
        let topCtrlPoint = CGPoint(x: 0, y: radius)
        
        let leftCtrlPoint = CGPoint(x: -radius, y: radius * 0.75)
        let rightCtrlPoint = CGPoint(x: radius, y: radius * 0.75)
        
        moveToPoint(topPoint)
        
        addCurveToPoint(CGPoint(x: -radius, y: 0), controlPoint1: topCtrlPoint, controlPoint2: leftCtrlPoint)
        
        addArcWithCenter(CGPointZero, radius: radius, startAngle: π, endAngle: 0, clockwise: true)
        
        addCurveToPoint(topPoint, controlPoint1: rightCtrlPoint, controlPoint2: topCtrlPoint)
        
        closePath()
        
        applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
    }
    
    public func addDrop(center: CGPoint, radius: CGFloat)
    {
        appendPath(UIBezierPath(dropWithCenter: center, radius: radius))
    }
}
