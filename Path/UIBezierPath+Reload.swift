//
//  UIBezierPath+Reload.swift
//  Path
//
//  Created by Christian Otkjær on 02/02/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Graphics

// MARK: - Reload Icon

extension UIBezierPath
{
    internal func addArrow(radius: CGFloat, center: CGPoint = .zero, arc: CGFloat)
    {
        let anchor = center + CGPoint(x: radius, y: 0)
        
        move(to: anchor)
        
        addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: -7 * arc / 8, clockwise: false)
        
        move(to: anchor)
        
        addLineOf(length: radius / 4, bearing: -π / 4)
        
        move(to: anchor)
        
        addLineOf(length: radius / 4, bearing: -3 * π / 4)
    }
    
    public convenience init(reloadSymbolWithCenter center: CGPoint,
                            radius: CGFloat,
                            arrows: Int)
    {
        self.init()
        
        guard arrows > 0 else { return }

        let arc = π2 / arrows
        
        for _ in 0..<arrows
        {
            addArrow(radius: radius, center: center, arc: arc)
            
            rotate(arc, around: center)
        }
        
        rotate(-arc / 16, around: center)
    }
}

