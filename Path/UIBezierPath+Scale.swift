//
//  UIBezierPath+Scale.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Graphics

//MARK: - Transform

public extension UIBezierPath
{
    // MARK: - Scale
    
    func scale<FP: CGFloatPair>(_ v: FP)
    {
        scale(sx: v[0], sy: v[1])
    }
    
    func scaled<FP: CGFloatPair>(_ v: FP) -> UIBezierPath
    {
        return scaled(sx: v[0], sy: v[0])
    }
    
    /// scales this path according to `s` in both x- and y-directions
    func scale<F: CGFloatConvertible>(_ s: F)
    {
        scale(sx: s, sy: s)
    }
    
    /// scales this path according to `sx` and `sy`
    func scale<F1: CGFloatConvertible, F2: CGFloatConvertible>(sx: F1, sy: F2)
    {
        apply(CGAffineTransform(scaleX: CGFloat(sx), y: CGFloat(sy)))
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path scaled according to `sx` and `sy`
    func scaled(sx: CGFloat, sy: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.scale(sx: sx, sy: sy)
        
        return path
    }
}
