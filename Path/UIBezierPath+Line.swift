//
//  UIBezierPath+Line.swift
//  Path
//
//  Created by Christian Otkjær on 02/02/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Graphics

// MARK: - Reload Icon

extension UIBezierPath
{
    func addLineOf(length: CGFloat, bearing direction: CGFloat)
    {
        let delta = CGPoint(x: cos(direction) * length, y: sin(direction) * length)
        
        addLine(to: currentPoint + delta)
    }
}
