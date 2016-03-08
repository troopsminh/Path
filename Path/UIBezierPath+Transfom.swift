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
    
    func translate(tx tx: CGFloat, ty: CGFloat)
    {
        applyTransform(CGAffineTransformMakeTranslation(tx, ty))
    }
    
    func translated(tx tx: CGFloat, ty: CGFloat) -> UIBezierPath
    {
        let path = self
        
        path.translate(tx: tx, ty: ty)
        
        return path
    }
    
    func translate<FP: CGFloatPair>(v: FP)
    {
        translate(tx: v[0], ty: v[1])
    }
    
    func translated<FP: CGFloatPair>(v: FP) -> UIBezierPath
    {
        return translated(tx: v[0], ty: v[0])
    }
    
    // MARK: - Rotate
    
    func rotate(angle: CGFloat)
    {
        applyTransform(CGAffineTransformMakeRotation(angle))
    }
    
    func rotated(angle: CGFloat) -> UIBezierPath
    {
        let path = self
        
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
    
    func scale(sx sx: CGFloat, sy: CGFloat)
    {
        applyTransform(CGAffineTransformMakeScale(sx, sy))
    }
    
    func scaled(sx sx: CGFloat, sy: CGFloat) -> UIBezierPath
    {
        let path = self
        
        path.scale(sx: sx, sy: sy)
        
        return path
    }
    
    // MARK: - Flipping
    
    func flipVertically()
    {
        flip(vertically: true, horizontally: false)
    }
    
    func flippedVertically() -> UIBezierPath
    {
        return flipped(vertically: true, horizontally: false)
    }

    func flipHorizontally()
    {
        flip(vertically: false, horizontally: true)
    }

    func flippedHorizontally() -> UIBezierPath
    {
        return flipped(vertically: false, horizontally: true)
    }

    func flip(vertically vertically: Bool, horizontally: Bool)
    {
        scale(sx: horizontally ? -1 : 1, sy: vertically ? -1 : 1)
    }
    
    func flipped(vertically vertically: Bool, horizontally: Bool) -> UIBezierPath
    {
        let path = self.copy() as! UIBezierPath
        
        path.flip(vertically: vertically, horizontally: horizontally)
        
        return path
    }

}

