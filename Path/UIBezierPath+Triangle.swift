//
//  UIBezierPath+Triangle.swift
//  Path
//
//  Created by Christian Otkjær on 16/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Graphics

// MARK: - Triangle

extension UIBezierPath
{
    public convenience init(triangleWithTopAt top: CGPoint, height: CGFloat, topAngle alpha: CGFloat = .pi / 3)
    {
        guard alpha <= .pi else { self.init(); debugPrint("A triangle must have a top-angle less than π"); return }
        
        let bottomWidthHalf = height * sin(alpha/2)
        
        let leftBottom = top + CGPoint(x: bottomWidthHalf, y: height)
        let rightBottom = top + CGPoint(x: -bottomWidthHalf, y: height)
        
        self.init(polygonWithCorners: top, leftBottom, rightBottom)
    }

    /// Initializes as an isosceles triangle of height pointing up. The base of the triangle will be at (0,0)
    public convenience init(triangleWithHeight height: CGFloat, topAngle alpha: CGFloat = .pi / 3)
    {
        guard alpha <= .pi else { self.init(); debugPrint("A triangle must have a top-angle less than π"); return }
        
        let baseWidthHalf = height * sin(alpha / 2)
        
        let top = CGPoint(x: 0, y: height)
        let baseLeft = CGPoint(x: baseWidthHalf, y: 0)
        let baseRight = CGPoint(x: -baseWidthHalf, y: 0)
        
        self.init(polygonWithCorners: top, baseLeft, baseRight)
    }
}
