//
//  SuperEllipse.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Graphics

// MARK: - Superellipse

// MARK: 𝑒

internal extension CGFloat
{
    static let 𝑒 = CGFloat(M_E)
}

public extension UIBezierPath
{
    convenience init(superEllipseInRect rect: CGRect, n: CGFloat = CGFloat.𝑒)
    {
        let a = rect.width / 2
        let b = rect.height / 2
        let n_2  = 2 / n
        let c = rect.center
        
        let x = { (t: CGFloat) -> CGFloat in
            let cost = cos(t)
            
            return c.x + sign(cost) * a * pow(abs(cost), n_2)
        }
        
        let y = { (t: CGFloat) -> CGFloat in
            let sint = sin(t)
            
            return c.y + sign(sint) * b * pow(abs(sint), n_2)
        }
        
        self.init()
        moveToPoint(rect.centerLeft)
        
        let factor = max((a+b)/10, 32)
        
        for t in (-π).stride(to: π, by: π/factor)
        {
            addLineToPoint(CGPoint(x: x(t), y: y(t)))
        }
        closePath()
    }
}
