//
//  Bars.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Bars

import Arithmetic
import Graphics

extension UIBezierPath
{
    public convenience init(bars: Int, inRect rect: CGRect)
    {
        self.init()
        
        switch abs(bars)
        {
        case 0:
            break
            
        case 1:
            
            let barPath = UIBezierPath()
            
            barPath.move(to: rect.centerLeft)
            barPath.addLine(to: rect.centerRight)
            
            barPath.lineCapStyle = .round
            
            append(barPath)
            
        default:
            
            let spaces = CGFloat(bars - 1)
            
            for bar in 0..<bars
            {
                let barPath = UIBezierPath()
                let factor = bar / spaces
                
                barPath.move(to: (rect.topLeft, rect.bottomLeft) ◊ factor)
                barPath.addLine(to: (rect.topRight, rect.bottomRight) ◊ factor)
                
                append(barPath)
            }
        }
    }
}
