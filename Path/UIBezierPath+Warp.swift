//
//  UIBezierPath+Warp.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

//MARK: - Warp

import Graphics

extension UIBezierPath
{
    // MARK: Text
    
    /// Warps `text` along this path. Works best if `text` has no newline characters 
    public func warp(text: String?, font: UIFont, textAlignment: NSTextAlignment = .natural) -> UIBezierPath
    {
        let path = UIBezierPath(string: text ?? "", withFont: font)
        
        return warp(path, align: textAlignment)
    }
    
    public func approximateBoundsForFont(_ font: UIFont) -> CGRect
    {
        let curves = cubicBezierCurves()
        
        let bounds = curves.map{ $0.approximateBoundsForFont(font) }
        
        guard let firstBounds = bounds.first else { return CGRect.zero }
        
        return bounds.reduce(firstBounds) { return $0.union($1) }
    }
    
    // MARK alignment
    
    // length is the length of the path around wich the parameter path is warped
    fileprivate func handleAlignment(_ path: UIBezierPath, length: CGFloat, alignment: NSTextAlignment) -> CGFloat
    {
        let width : CGFloat
        
        switch alignment
        {
        case .center:
            width = max(length, path.bounds.width)
            path.translate(tx: (width - path.bounds.width) / 2, ty: 0)
            
        case .left:
            width = length
            path.translate(tx: -path.bounds.minX, ty: 0)
            
        case .right:
            width = length
            path.translate(tx: length - path.bounds.maxX, ty: 0)
            
        case .justified:
            width = path.bounds.width
            path.translate(tx: -path.bounds.minX, ty: 0)
            
        case .natural:
            switch UIApplication.shared.userInterfaceLayoutDirection
            {
            case .leftToRight:
                return handleAlignment(path, length: length, alignment: .left)
                
            case .rightToLeft:
                return handleAlignment(path, length: length, alignment: .right)
            }
        }
        
        return width
    }
    
    // MARK: Warp any path (along its x-axis)
    
    fileprivate func warp(_ path: UIBezierPath, align: NSTextAlignment = .justified) -> UIBezierPath
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
        
        func warpPoint(_ point: CGPoint) -> CGPoint?
        {
            guard point.x >= 0 && point.x <= width else { return nil }
            
            let distanceOnPath = point.x / width
            
            let (index, distanceAtCurveStart) = distances.last { $0 < distanceOnPath } ?? (0, 0)
            
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
        
        var subPathBeginPoint = CGPoint.zero
        var beginPoint = CGPoint.zero
        
        let warpedPath : UIBezierPath = UIBezierPath()
        
        for element in path.elements
        {
            switch element
            {
            case .moveToPoint(let point):
                
                if let warpedPoint = warpPoint(point)
                {
                    subPathBeginPoint = point
                    beginPoint = point
                    
                    warpedPath.move(to: warpedPoint)
                }
                
            case .addLineToPoint(let endPoint):
                
                if let warpedCtrlPoint1 = warpPoint((2 * beginPoint + endPoint) / 3)
                    , let warpedCtrlPoint2 = warpPoint((beginPoint + 2 * endPoint) / 3)
                    , let warpedEndPoint = warpPoint(endPoint)
                {
                    beginPoint = endPoint
                    
                    warpedPath.addCurve(to: warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                }
                
            case .addQuadCurveToPoint(let ctrlPoint, let endPoint):
                
                if let warpedCtrlPoint1 = warpPoint((2 * ctrlPoint + beginPoint) / 3)
                    , let warpedCtrlPoint2 = warpPoint((2 * ctrlPoint + endPoint) / 3)
                    , let warpedEndPoint = warpPoint(endPoint)
                {
                    beginPoint = endPoint
                    
                    warpedPath.addCurve(to: warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                }
                
            case .addCurveToPoint(let ctrlPoint1, let ctrlPoint2, let endPoint):
                
                if let warpedCtrlPoint1 = warpPoint(ctrlPoint1)
                    , let warpedCtrlPoint2 = warpPoint(ctrlPoint2)
                    , let warpedEndPoint = warpPoint(endPoint)
                {
                    beginPoint = endPoint
                    
                    warpedPath.addCurve(to: warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                }
                
            case .closeSubpath:
                
                let endPoint = subPathBeginPoint
                
                if endPoint != beginPoint
                {
                    if let warpedCtrlPoint1 = warpPoint((2 * beginPoint + endPoint) / 3)
                        , let warpedCtrlPoint2 = warpPoint((beginPoint + 2 * endPoint) / 3)
                        , let warpedEndPoint = warpPoint(endPoint)
                    {
                        warpedPath.addCurve(to: warpedEndPoint, controlPoint1: warpedCtrlPoint1, controlPoint2: warpedCtrlPoint2)
                    }
                }
                
                warpedPath.close()
                
                beginPoint = CGPoint.zero
                subPathBeginPoint = CGPoint.zero
            }
        }
        
        return warpedPath
    }
}
