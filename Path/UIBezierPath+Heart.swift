//
//  UIBezierPath+Heart.swift
//  Path
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Graphics

private func heartX(_ t: CGFloat) -> CGFloat { return 16 * pow(sin(t), 3) }

private func heartY(_ t: CGFloat) -> CGFloat
{
    let a = 13 * cos(t)
    let b = -5 * cos(2 * t)
    let c = -2 * cos(3 * t)
    let d = -cos(4 * t)
    
    return a + b + c + d
}

// MARK: - Heart

extension UIBezierPath
{
    public convenience init(heartInRect rect: CGRect)
    {
        self.init()
        
        let radius = max(10, min(rect.width, rect.height) / 2)
        
        let factor = radius / 16
        
        func heart(_ t: CGFloat) -> CGPoint { return CGPoint(x: heartX(t), y: heartY(t)) * factor }
        
        move(to: heart(0))
        
        let step = min(0.1, 10/radius)
        
        for t in stride(from: step, to: CGFloat.π2, by: step)
        {
            addLine(to: heart(t))
        }
        
        close()
        
        transform(toFit: rect)
    }
    
    public convenience init(heartCenteredAt center: CGPoint, radius: CGFloat)
    {
        self.init()
        
        let factor = radius / 16
        
        func heart(_ t: CGFloat) -> CGPoint { return CGPoint(x: heartX(t), y: heartY(t)) * factor }
        
        move(to: heart(0))

        let step = min(0.1, 10/radius)
        
        for t in stride(from: step, to: CGFloat.π2, by: step)
        {
            addLine(to: heart(t))
        }
        
        close()
        
        translate(center)
    }
}
