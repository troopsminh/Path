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
        
        addCresentWith(center: center, radius: radius, centerAngle: centerAngle, angleWidth: angleWidth)
    }

     func addCresentWith(center: CGPoint, radius: CGFloat, centerAngle: CGFloat, angleWidth: CGFloat)
    {
        let theta = min(π2, abs(angleWidth)) / 2
        
        let r1 = radius
        
        let d = (1.5 - sin(theta)) * r1
        
        let c1 = CGPoint(x: 0, y: 0)
        let c2 = CGPoint(x: -d, y: 0)
        
        let p1 = CGPoint(x: cos(theta) * r1, y: sin(theta) * r1)
        
        let r2 = sqrt(pow(p1.x - c2.x, 2) + pow(p1.y - c2.y, 2))
        
        let phi = asin( sin(theta) * r1 / r2 )
        
        let cresent = UIBezierPath()
        
        cresent.move(to: p1)
        cresent.addArc(withCenter: c1, radius: r1, startAngle: theta, endAngle: -theta, clockwise: false)
        cresent.addArc(withCenter: c2, radius: r2, startAngle: -phi, endAngle: phi, clockwise: true)
        cresent.close()
        
        let rotation = centerAngle.normalized()
        
        if rotation != 0 && rotation != CGFloat.π2
        {
            cresent.rotate(-rotation)
//            cresent.apply(CGAffineTransform(rotationAngle: -rotation))
        }
        
        if center != CGPoint.zero
        {
            cresent.translate(center)
        }
        
        append(cresent)
    }
    
    public func addCresentWith(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
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
        
        addCresentWith(center: center, radius: radius, centerAngle: centerAngle, angleWidth: angleWidth)
    }
}
