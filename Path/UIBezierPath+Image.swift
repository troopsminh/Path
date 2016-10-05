//
//  UIBezierPath+Image.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public extension UIBezierPath
{
    func image(
        strokeColor: UIColor? = UIColor.black,
        fillColor: UIColor? = nil,
        backgroundColor: UIColor? = nil) -> UIImage
    {
        let frame = strokeBounds.integral
        
        let path = translated(tx: -frame.minX, ty: -frame.size.height - frame.minY).flippedVertically()

        let opaque = backgroundColor?.cgColor.alpha == 1
        
        UIGraphicsBeginImageContextWithOptions(frame.size, opaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        if backgroundColor?.cgColor.alpha > 0
        {
            backgroundColor?.setFill()
            
            UIBezierPath(rect: frame).fill()
            
//            UIBezierPath(rect: CGRect(dictionaryRepresentation: frame.size as! CFDictionary)!).fill()
        }
        
        if fillColor?.cgColor.alpha > 0
        {
            fillColor?.setFill()
            path.fill()
        }
        
        if strokeColor?.cgColor.alpha > 0 && lineWidth > 0
        {
            strokeColor?.setStroke()
            path.stroke()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}
