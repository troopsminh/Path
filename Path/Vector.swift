//
//  Vector.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic
import Graphics

public extension UIBezierPath
{
    convenience init(vector: CGVector, atPoint point: CGPoint = CGPointZero)
    {
        self.init()
        
        guard vector.magnitude > 0.01 else { moveToPoint(point); addLineToPoint(point); return }
        
        let toPoint = point + vector
        let tailWidth = max(1, vector.magnitude / 30)
        let headWidth = max(3, vector.magnitude / 10)
        
        let headStartPoint = (point, toPoint) ◊ 0.9
        
        let v = vector.perpendicular().normalized
        
        moveToPoint(toPoint)
        addLineToPoint(headStartPoint + v * headWidth)
        addLineToPoint(headStartPoint + v * tailWidth)
        addLineToPoint(point + v * tailWidth)
        
        addLineToPoint(point - v * tailWidth)
        addLineToPoint(headStartPoint - v * tailWidth)
        addLineToPoint(headStartPoint - v * headWidth)
        
        closePath()
    }
}
