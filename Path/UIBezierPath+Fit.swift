//
//  UIBezierPath+Fit.swift
//  Path
//
//  Created by Christian Otkjær on 07/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics
import Arithmetic

//public enum Alignment
//{
//    case Center
//    case TopCenter
//    case TopLeft
//    case TopRight
//}

public extension UIBezierPath
{
    /// scales path to fit in `size`
    func scale(toFit size: CGSize)
    {
        let pathBounds = bounds
        
        let scaleFactor = min(size.width / pathBounds.width, size.height / pathBounds.height)
        
        scale(sx: scaleFactor, sy: scaleFactor)
    }
    
    /// transforms path to fit in `rect`
    func transform(toFit rect: CGRect, alignment: CGPoint = CGPoint(0.5, 0.5))
    {
        scale(toFit: rect.size)

        align(in: rect, alignment: alignment)
    }
}
