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
    func scaleToFit(size: CGSize)
    {
        let pathBounds = bounds
        
        let scaleFactor = min(size.width / pathBounds.width, size.height / pathBounds.height)
        
        scale(sx: scaleFactor, sy: scaleFactor)
    }
    
   
    
    func transformToFit(rect: CGRect, alignment: CGPoint = CGPoint(0.5, 0.5))
    {
        scaleToFit(rect.size)

        alignIn(rect, alignment: alignment)
    }
}
