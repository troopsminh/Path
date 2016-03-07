//
//  UIBezierPath+Image.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics

public extension UIBezierPath
{
    func image(
        strokeColor strokeColor: UIColor? = UIColor.blackColor(),
        fillColor: UIColor? = nil,
        backgroundColor: UIColor? = nil) -> UIImage
    {
        let frame = bounds.insetBy(dx: -lineWidth, dy: -lineWidth).integral
        
        let path = self
        
        path.applyTransform(CGAffineTransformMakeTranslation(1 - frame.minX, -frame.size.height - frame.minY))
        path.applyTransform(CGAffineTransformMakeScale(1, -1))

        let opaque = backgroundColor?.CGColor.alpha == 1
        
        UIGraphicsBeginImageContextWithOptions(frame.size, opaque, 0)
        defer { UIGraphicsEndImageContext() }
        
        if backgroundColor?.CGColor.alpha > 0
        {
            backgroundColor?.setFill()
            
            UIBezierPath(rect: path.bounds).fill()
        }
        
        if fillColor?.CGColor.alpha > 0
        {
            fillColor?.setFill()
            path.fill()
        }
        
        if strokeColor?.CGColor.alpha > 0
        {
            strokeColor?.setStroke()
            path.stroke()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
