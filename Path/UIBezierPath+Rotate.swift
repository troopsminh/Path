//
//  UIBezierPath+Rotate.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

public extension UIBezierPath
{
    // MARK: - Rotate
    
    /// Rotates this path `theta` radians
    func rotate(_ theta: CGFloat)
    {
        if theta != 0
        {
            apply(CGAffineTransform(rotationAngle: theta))
        }
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path rotated `theta` radians
    func rotated(_ theta: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.rotate(theta)
        
        return path
    }
}
