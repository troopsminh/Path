//
//  UIBezierPath+Curves.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
import Arithmetic
import Geometry
import Graphics
import Collections

// MARK: - Cubic Bezier Curves

extension UIBezierPath
{
    public func cubicBezierCurves() -> [CubicBezierCurve]
    {
        var curves = Array<CubicBezierCurve>()
        
        var subPathBeginPoint = CGPointZero
        var beginPoint = CGPointZero
        
        for element in elements
        {
            switch element
            {
            case .MoveToPoint(let point):
                
                subPathBeginPoint = point
                beginPoint = point
                
                
            case .AddLineToPoint(let endPoint):
                
                let ctrlPoint1 = (2 * beginPoint + endPoint) / 3
                let ctrlPoint2 = (beginPoint + 2 * endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .AddQuadCurveToPoint(let ctrlPoint, let endPoint):
                
                // A quadratic Bezier curve can be always represented by a cubic one by applying the degree elevation algorithm. The resulting cubic representation will share its anchor points with the original quadratic, while the control points will be at 2/3 of the quadratic handle segments:
                let ctrlPoint1 = (2 * ctrlPoint + beginPoint) / 3
                let ctrlPoint2 = (2 * ctrlPoint + endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
            case .AddCurveToPoint(let ctrlPoint1, let ctrlPoint2, let endPoint):
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .CloseSubpath:
                
                let endPoint = subPathBeginPoint
                
                let ctrlPoint1 = (2 * beginPoint + endPoint) / 3
                let ctrlPoint2 = (beginPoint + 2 * endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = CGPointZero
                subPathBeginPoint = CGPointZero
                
            }
        }
        
        return curves
    }
}

//MARK: - Warp

extension UIBezierPath
{
    // MARK: Text
    
    public func warp(text: String, font: UIFont, textAlignment: NSTextAlignment = .Natural) -> UIBezierPath
    {
        let path = UIBezierPath(string: text, withFont: font)
        
        return warp(path, align: textAlignment)
    }
    
    public func approximateBoundsForFont(font: UIFont) -> CGRect
    {
        let curves = cubicBezierCurves()
        
        let bounds = curves.map{ $0.approximateBoundsForFont(font) }
        
        guard let firstBounds = bounds.first else { return CGRectZero }
        
        return bounds.reduce(firstBounds) { return $0.union($1) }
    }
    
    // MARK: Warp any other path

    // MARK alignment

    private func handleAlignment(path: UIBezierPath, length: CGFloat, alignment: NSTextAlignment) -> CGFloat
    {
        var width = CGFloat(0)
        
        switch alignment
        {
        case .Center:
            width = max(length, path.bounds.width)
            path.applyTransform(CGAffineTransformMakeTranslation((width - path.bounds.width) / 2, 0))
            
        case .Left:
            path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, 0))
            width = length
            
        case .Right:
            path.applyTransform(CGAffineTransformMakeTranslation(length - path.bounds.maxX, 0))
            width = length
            
        case .Justified:
            path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, 0))
            width = path.bounds.width
            
        case .Natural:
            switch UIApplication.sharedApplication().userInterfaceLayoutDirection
            {
            case .LeftToRight:
                path.applyTransform(CGAffineTransformMakeTranslation(-path.bounds.minX, 0))
                width = length
                
            case .RightToLeft:
                path.applyTransform(CGAffineTransformMakeTranslation(length - path.bounds.maxX, 0))
                width = length
            }
        }
        
        return width
    }
    
    private func warp(path: UIBezierPath, align: NSTextAlignment = .Justified) -> UIBezierPath
    {
        let curves = cubicBezierCurves()
        
        guard let firstCurve = curves.first else { return UIBezierPath() }
        
        let length = curves.reduce(0) { $0 + $1.length }
        
        var curveLength = CGFloat(0)
        
        var distances = Array<CGFloat>()
        
        for curve in curves
        {
            distances.append(curveLength / length)
            
            curveLength += curve.length
        }
        
        distances.append(1)
        
        let width = handleAlignment(path, length: length, alignment: align)
        
        func warpPoint(point: CGPoint) -> CGPoint?
        {
            guard point.x >= 0 && point.x <= width else { return nil }
            
            let distanceOnPath = point.x / width
            
            let (index, distanceAtCurveStart) = distances.lastWhere{ $0 < distanceOnPath } ?? (0, 0)
            
            if let curve = curves.get(index), let distanceAtCurveEnd = distances.get(index + 1)
            {
                let distanceSpan = distanceAtCurveEnd - distanceAtCurveStart
                
                let distance = (distanceOnPath - distanceAtCurveStart) / distanceSpan
                
                let time = curve.timeForDistance(distance)
                
                let curvePosition = curve.positionAt(time)
                
                let perpendicular = curve.tangentAt(time).perpendicular(clockwise: false).normalized
                
                let warpedPoint = curvePosition + perpendicular * point.y
                
                return warpedPoint
            }
            
            return nil
        }
        
        var subPathBeginPoint = CGPointZero
        var beginPoint = CGPointZero
        
        let warpedPath : UIBezierPath = UIBezierPath()
        
        for element in path.elements
        {
            switch element
            {
            case .MoveToPoint(let point):
                
                if let warpedPoint = warpPoint(point)
                {
                    subPathBeginPoint = point
                    beginPoint = point
                    
                    warpedPath.moveToPoint(warpedPoint)
                }
                
            case .AddLineToPoint(let endPoint):
                
                if let warpedCtrlPoint1 = warpPoint((2 * beginPoint + endPoint) / 3)
                    , let warpedCtrlPoint2 = warpPoint((beginPoint + 2 * endPoint) / 3)
                    , let warpedEndPoint = warpPoint(endPoint)
                {
                    beginPoint = endPoint
                    
                    warpedPath.addCurveToPoint(warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                }
                
            case .AddQuadCurveToPoint(let ctrlPoint, let endPoint):
                
                if let warpedCtrlPoint1 = warpPoint((2 * ctrlPoint + beginPoint) / 3)
                    , let warpedCtrlPoint2 = warpPoint((2 * ctrlPoint + endPoint) / 3)
                    , let warpedEndPoint = warpPoint(endPoint)
                {
                    beginPoint = endPoint
                    
                    warpedPath.addCurveToPoint(warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                }
                
            case .AddCurveToPoint(let ctrlPoint1, let ctrlPoint2, let endPoint):
                
                if let warpedCtrlPoint1 = warpPoint(ctrlPoint1)
                    , let warpedCtrlPoint2 = warpPoint(ctrlPoint2)
                    , let warpedEndPoint = warpPoint(endPoint)
                {
                    beginPoint = endPoint
                    
                    warpedPath.addCurveToPoint(warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                }
                
            case .CloseSubpath:
                
                let endPoint = subPathBeginPoint
                
                if endPoint != beginPoint
                {
                    if let warpedCtrlPoint1 = warpPoint((2 * beginPoint + endPoint) / 3)
                        , let warpedCtrlPoint2 = warpPoint((beginPoint + 2 * endPoint) / 3)
                        , let warpedEndPoint = warpPoint(endPoint)
                    {
                        warpedPath.addCurveToPoint(warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                    }
                }
                
                warpedPath.closePath()
                
                beginPoint = CGPointZero
                subPathBeginPoint = CGPointZero
            }
        }
        
        return warpedPath
    }
}

//MARK: - Cubic Bezier Curves

public extension UIBezierPath
{
    convenience init(withCubicBezierCurve c: CubicBezierCurve)
    {
        self.init()
        
        moveToPoint(c.beginPoint)
        addCurveToPoint(c.endPoint, controlPoint1: c.ctrlPoint1, controlPoint2: c.ctrlPoint2)
    }
    
    convenience init(withCubicBezierCurve p0: CGPoint, p1: CGPoint, p2: CGPoint, p3: CGPoint)
    {
        self.init()
        
        moveToPoint(p0)
        addCurveToPoint(p3, controlPoint1: p1, controlPoint2: p2)
    }
}