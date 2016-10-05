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
        
        move(to: topPoint)
        
        addCurve(to: CGPoint(x: -radius, y: 0), controlPoint1: topCtrlPoint, controlPoint2: leftCtrlPoint)
        
        addArc(withCenter: CGPoint.zero, radius: radius, startAngle: π, endAngle: 0, clockwise: true)
        
        addCurve(to: topPoint, controlPoint1: rightCtrlPoint, controlPoint2: topCtrlPoint)
        
        close()
        
        apply(CGAffineTransform(translationX: center.x, y: center.y))
    }
    
    public func addDrop(_ center: CGPoint, radius: CGFloat)
    {
        append(UIBezierPath(dropWithCenter: center, radius: radius))
    }
}
