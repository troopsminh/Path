//
//  UIBezierPath+Curves.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
import Arithmetic
import Graphics
import Collections

// MARK: - Cubic Bezier Curves

extension UIBezierPath
{
    public func cubicBezierCurves() -> [CubicBezierCurve]
    {
        var curves = Array<CubicBezierCurve>()
        
        var subPathBeginPoint = CGPoint.zero
        var beginPoint = CGPoint.zero
        
        for element in elements
        {
            switch element
            {
            case .moveToPoint(let point):
                
                subPathBeginPoint = point
                beginPoint = point
                
                
            case .addLineToPoint(let endPoint):
                
                let ctrlPoint1 = (2 * beginPoint + endPoint) / 3
                let ctrlPoint2 = (beginPoint + 2 * endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .addQuadCurveToPoint(let ctrlPoint, let endPoint):
                
                // A quadratic Bezier curve can be always represented by a cubic one by applying the degree elevation algorithm. The resulting cubic representation will share its anchor points with the original quadratic, while the control points will be at 2/3 of the quadratic handle segments:
                let ctrlPoint1 = (2 * ctrlPoint + beginPoint) / 3
                let ctrlPoint2 = (2 * ctrlPoint + endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .addCurveToPoint(let ctrlPoint1, let ctrlPoint2, let endPoint):
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .closeSubpath:
                
                let endPoint = subPathBeginPoint
                
                let ctrlPoint1 = (2 * beginPoint + endPoint) / 3
                let ctrlPoint2 = (beginPoint + 2 * endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = CGPoint.zero
                subPathBeginPoint = CGPoint.zero
                
            }
        }
        
        return curves
    }
}

//MARK: - Cubic Bezier Curves

public extension UIBezierPath
{
    convenience init(withCubicBezierCurves cs: [CubicBezierCurve])
    {
        self.init()
        
        var beginPoint : CGPoint?
        
        for c in cs
        {
            if beginPoint != c.beginPoint
            {
                move(to: c.beginPoint)
            }
            addCurve(to: c.endPoint, controlPoint1: c.ctrlPoint1, controlPoint2: c.ctrlPoint2)
            beginPoint = c.endPoint
        }
    }

    convenience init(withCubicBezierCurve c: CubicBezierCurve)
    {
        self.init()
        
        move(to: c.beginPoint)
        addCurve(to: c.endPoint, controlPoint1: c.ctrlPoint1, controlPoint2: c.ctrlPoint2)
    }
    
    convenience init(withCubicBezierCurve p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint)
    {
        self.init()
        
        move(to: p0)
        addCurve(to: p3, controlPoint1: p1, controlPoint2: p2)
    }
}
