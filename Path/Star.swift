//
//  Star.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Graphics

extension UIBezierPath
{
    public convenience init(starWithCenter center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        spikes: Int)
    {
        self.init()
        
        guard spikes > 2 else { return }
        
        let angle = π / spikes
        
        var radius = (outerRadius, innerRadius)
        
        move(to: CGPoint(x: radius.0, y: 0))
        
        for _ in 0..<spikes*2
        {
            apply(CGAffineTransform(rotationAngle: angle))
            
            swap(&radius.0, &radius.1)
            
            addLine(to: CGPoint(x: radius.0, y: 0))
        }
        
        apply(CGAffineTransform(translationX: center.x, y: center.y))
        
        close()
    }
    
    public func addStar(_ center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        spikes: Int)
    {
        append(UIBezierPath(starWithCenter: center, innerRadius: innerRadius, outerRadius: outerRadius, spikes: spikes))
    }
}
