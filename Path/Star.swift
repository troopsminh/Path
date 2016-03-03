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
        
        moveToPoint(CGPoint(x: radius.0, y: 0))
        
        for _ in 0..<spikes*2
        {
            applyTransform(CGAffineTransformMakeRotation(angle))
            
            swap(&radius.0, &radius.1)
            
            addLineToPoint(CGPoint(x: radius.0, y: 0))
        }
        
        applyTransform(CGAffineTransformMakeTranslation(center.x, center.y))
        
        closePath()
    }
    
    public func addStar(center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        spikes: Int)
    {
        appendPath(UIBezierPath(starWithCenter: center, innerRadius: innerRadius, outerRadius: outerRadius, spikes: spikes))
    }
}
