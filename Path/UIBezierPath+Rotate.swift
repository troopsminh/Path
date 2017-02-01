//
//  UIBezierPath+Rotate.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics

public extension UIBezierPath
{
    // MARK: - Rotate
    
    /// Rotates this path `theta` radians around `origo`
    func rotate(_ theta: CGFloat, around origo: CGPoint = .zero)
    {
        guard theta != 0 else { return }
        
        if origo != .zero { translate(-origo) }
        apply(CGAffineTransform(rotationAngle: theta))
        if origo != .zero { translate(origo) }
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path rotated `theta` radians around `origo`
    func rotated(_ theta: CGFloat, around origo: CGPoint = .zero) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.rotate(theta, around: origo)
        
        return path
    }
}
