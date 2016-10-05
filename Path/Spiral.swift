//
//  Spiral.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics
import Arithmetic

//MARK: - Spiral

extension UIBezierPath
{
    public convenience init(spiralWithCenter center: CGPoint = CGPoint.zero, radius: CGFloat, steps: CGFloat, loopCount: CGFloat)
    {
        self.init()
        
        let away = radius / steps
        let around = loopCount / steps * 2 * CGFloat(M_PI)
        
        let points = stride(from: 1, through: Int(ceil(steps)), by: 1).map { (step) -> CGPoint in
            let x = cos(step * around) * step * away
            let y = sin(step * around) * step * away
            
            return CGPoint(x: x, y: y) + center
        }
        
        move(to: center)
        
        points.forEach { addLine(to: $0) }
    }
}


//MARK: - Archimedean Spiral

public extension UIBezierPath
{
    public convenience init(
        archimedeanSpiralWithCenter center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        clockwise: Bool,
        inToOut: Bool,
        loops : CGFloat)
    {
        self.init()
        
        addArchimedeanSpiral(center, innerRadius: innerRadius, outerRadius: outerRadius, clockwise: clockwise, inToOut: inToOut, loops: loops)
    }
    
    func addArchimedeanSpiral(
        _ center: CGPoint,
        innerRadius: CGFloat,
        outerRadius: CGFloat,
        clockwise: Bool,
        inToOut: Bool,
        loops : CGFloat)
    {
        let spiral = UIBezierPath()
        
        let a = innerRadius
        let b = outerRadius - innerRadius
        
        var phiStep = π_2
        
        var lastPointAdded = CGPoint(x: a, y: 0)
        
        spiral.move(to: lastPointAdded)
        
        var phi = CGFloat(0)
        let phiMax = loops * π2
        
        while phi < phiMax
//        for phi in CGFloat(0).stride(to: loops * π2, by: phiStep)
        
//        for var phi: CGFloat = 0; phi < loops * π2; phi += phiStep
        {
            let c = a + b * phi / (loops * π2)
            
            let point = CGPoint(x: cos(phi) * c, y: sin(phi) * c)
            
            if pow(point.x - lastPointAdded.x,2) + pow(point.y - lastPointAdded.y,2) > c
            {
                phi -= phiStep
                phiStep /= 2
            }
            else
            {
                lastPointAdded = point
                spiral.addLine(to: point)
            }
            
            phi += phiStep
        }
        
        spiral.translate(tx: center.x, ty: center.y)
        
        append(spiral)
    }
}
