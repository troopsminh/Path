//
//  UIBezierPath+Gear.swift
//  Path
//
//  Created by Christian Otkjær on 02/02/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Graphics

extension UIBezierPath
{
    public convenience init(gearWithCenter center: CGPoint,
                            innerRadius: CGFloat,
                            outerRadius: CGFloat,
                            teeth: Int)
    {
        self.init()
        
        guard teeth > 2 else { return }
        
        let angle = π / teeth
        
        var radius = (outerRadius, innerRadius)
        
        addArc(withCenter: center, radius: innerRadius/2, startAngle: 0, endAngle: π2, clockwise: true)
        
        move(to: center + CGPoint(x: radius.0, y: 0))
        
        for _ in 0..<teeth*2
        {
            addArc(withCenter: center, radius: radius.0, startAngle: 0, endAngle: -angle, clockwise: false)
            
            apply(CGAffineTransform(rotationAngle: angle))
            
            swap(&radius.0, &radius.1)
        }
        
        apply(CGAffineTransform(translationX: center.x, y: center.y))
        
        close()
    }
}
