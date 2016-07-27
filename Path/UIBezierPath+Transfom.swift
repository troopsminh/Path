//
//  UIBezierPath+Transform.swift
//  Path
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Graphics

//MARK: - Transform

public extension UIBezierPath
{
    // MARK: - Translate
    
    /// Translates this path translated by `tx` and `ty`
    func translate(tx tx: CGFloat, ty: CGFloat)
    {
        applyTransform(CGAffineTransformMakeTranslation(tx, ty))
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path translated by `tx` and `ty`
    func translated(tx tx: CGFloat, ty: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.translate(tx: tx, ty: ty)
        
        return path
    }
    
    /// Translates this path translated by `v`
    func translate<FP: CGFloatPair>(v: FP)
    {
        translate(tx: v[0], ty: v[1])
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path translated by `tx` and `ty`
    func translated<FP: CGFloatPair>(v: FP) -> UIBezierPath
    {
        return translated(tx: v[0], ty: v[1])
    }
    
    // MARK: - Rotate
    
    /// Rotates this path `angle` radians
    func rotate(angle: CGFloat)
    {
        applyTransform(CGAffineTransformMakeRotation(angle))
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path rotated `angle`
    func rotated(angle: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.rotate(angle)
        
        return path
    }
    
    // MARK: - Scale
    
    func scale<FP: CGFloatPair>(v: FP)
    {
        scale(sx: v[0], sy: v[1])
    }
    
    func scaled<FP: CGFloatPair>(v: FP) -> UIBezierPath
    {
        return scaled(sx: v[0], sy: v[0])
    }

    /// scales this path according to `s` in both x- and y-directions
    func scale<F: CGFloatConvertible>(s: F)
    {
        scale(sx: s, sy: s)
    }
    
    /// scales this path according to `sx` and `sy`
    func scale<F1: CGFloatConvertible, F2: CGFloatConvertible>(sx sx: F1, sy: F2)
    {
        applyTransform(CGAffineTransformMakeScale(CGFloat(sx), CGFloat(sy)))
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path scaled according to `sx` and `sy`
    func scaled(sx sx: CGFloat, sy: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.scale(sx: sx, sy: sy)
        
        return path
    }
    
    // MARK: - Flipping
    
    /// Flips this path around x-axis
    func flipVertically()
    {
        flip(vertically: true, horizontally: false)
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path flipped around x-axis
    func flippedVertically() -> UIBezierPath
    {
        return flipped(vertically: true, horizontally: false)
    }

    /// Flips this path around y-axis
    func flipHorizontally()
    {
        flip(vertically: false, horizontally: true)
    }

    /// Returns a new `UIBezierPath` that is a copy of this path flipped around y-axis
    func flippedHorizontally() -> UIBezierPath
    {
        return flipped(vertically: false, horizontally: true)
    }

    /// Flips this path around none, one, or both axis
    func flip(vertically vertically: Bool, horizontally: Bool)
    {
        scale(sx: horizontally ? -1 : 1, sy: vertically ? -1 : 1)
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path flipped around none, one, or both axis
    func flipped(vertically vertically: Bool, horizontally: Bool) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.flip(vertically: vertically, horizontally: horizontally)
        
        return path
    }

}

