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
    convenience init(vector: CGVector, atPoint point: CGPoint = CGPoint.zero)
    {
        self.init()
        
        guard vector.magnitude > 0.01 else { move(to: point); addLine(to: point); return }
        
        let toPoint = point + vector
        let tailWidth = max(1, vector.magnitude / 30)
        let headWidth = max(3, vector.magnitude / 10)
        
        let headStartPoint = (point, toPoint) ◊ 0.9
        
        let v = vector.perpendicular().normalized
        
        move(to: toPoint)
        addLine(to: headStartPoint + v * headWidth)
        addLine(to: headStartPoint + v * tailWidth)
        addLine(to: point + v * tailWidth)
        
        addLine(to: point - v * tailWidth)
        addLine(to: headStartPoint - v * tailWidth)
        addLine(to: headStartPoint - v * headWidth)
        
        close()
    }
}
