//
//  UIBezierPath+Bounds.swift
//  Path
//
//  Created by Christian Otkjær on 08/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Bounds

extension UIBezierPath
{
    /**
     The bounding rectangle of the path STROKED with the current stroke-properties; line-width, line-cap-stype, line-join-style, and miter limit.
     The value in this property represents the smallest rectangle that completely encloses all points in the STROKED path, including any control points for cubic and quadratic Bézier curves.
     */
    public var strokeBounds : CGRect
        {
            if let strokePath = CGPath(__byStroking: self.cgPath, transform: nil, lineWidth: lineWidth, lineCap: lineCapStyle, lineJoin: lineJoinStyle, miterLimit: miterLimit)
            {
                return UIBezierPath(cgPath: strokePath).bounds
            }
            
            return bounds
    }
}
