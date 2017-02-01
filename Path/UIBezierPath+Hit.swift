//
//  UIBezierPath+Hit.swift
//  Path
//
//  Created by Christian Otkjær on 13/01/17.
//  Copyright © 2017 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - <#comment#>

extension UIBezierPath
{
    public func strokeContains(_ point: CGPoint) -> Bool
    {
        let p = cgPath.copy(strokingWithWidth: lineWidth, lineCap: lineCapStyle, lineJoin: lineJoinStyle, miterLimit: miterLimit)
        
        return UIBezierPath(cgPath: p).contains(point)
    }
}
