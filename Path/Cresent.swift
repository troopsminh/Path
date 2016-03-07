//
//  Cresent.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics

//MARK: - Cresent

public extension UIBezierPath
{
    public convenience init(cresentWithCenter center: CGPoint, radius: CGFloat, centerAngle: CGFloat, angleWidth: CGFloat)
    {
        self.init()
        
        addCresentWithCenter(center, radius: radius, centerAngle: centerAngle, angleWidth: angleWidth)
    }

     func addCresentWithCenter(center: CGPoint, radius: CGFloat, centerAngle: CGFloat, angleWidth: CGFloat)
    {
        let alpha = min(π2, abs(angleWidth)) / 2
        
        let r1 = radius
        
        let d = (1.5 - sin(alpha)) * r1
        
        let c1 = CGPoint(x: 0, y: 0)
        let c2 = CGPoint(x: -d, y: 0)
        
        let p1 = CGPoint(x: cos(alpha) * r1, y: sin(alpha) * r1)
        
        let r2 = sqrt(pow(p1.x - c2.x, 2) + pow(p1.y - c2.y, 2))
        
        let beta = asin( sin(alpha) * r1 / r2 )
        
        let cresent = UIBezierPath()
        
        cresent.moveToPoint(p1)
        cresent.addArcWithCenter(c1, radius: r1, startAngle: alpha, endAngle: -alpha, clockwise: false)
        cresent.addArcWithCenter(c2, radius: r2, startAngle: -beta, endAngle: beta, clockwise: true)
        cresent.closePath()
        
        let rotation = centerAngle.normalized()
        
        if rotation != 0
        {
            cresent.applyTransform(CGAffineTransformMakeRotation(-rotation))
        }
        
        if center != CGPointZero
        {
            cresent.applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
        }
        
        appendPath(cresent)
    }
    
    public func addCresentWithCenter(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
    {
        let normalStartAngle = clockwise ? startAngle.normalized() : endAngle.normalized()
        let normalEndAngle = clockwise ? endAngle.normalized() : startAngle.normalized()
        
        var centerAngle = ((normalStartAngle + normalEndAngle) / 2).normalized()
        var angleWidth = max(normalStartAngle, normalEndAngle) - min(normalStartAngle, normalEndAngle).normalized()
        
        if !clockwise
        {
            angleWidth = π2 - angleWidth
            centerAngle += π
        }
        
        addCresentWithCenter(center, radius: radius, centerAngle: centerAngle, angleWidth: angleWidth)
    }
}
