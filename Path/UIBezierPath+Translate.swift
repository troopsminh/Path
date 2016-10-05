//
//  UIBezierPath+Translate.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation
import Graphics

public extension UIBezierPath
{
    // MARK: - Translate
    
    /// Translates this path translated by `tx` and `ty`
    func translate(tx: CGFloat, ty: CGFloat)
    {
        if tx != 0 || ty != 0
        {
            apply(CGAffineTransform(translationX: tx, y: ty))
        }
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path translated by `tx` and `ty`
    func translated(tx: CGFloat, ty: CGFloat) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.translate(tx: tx, ty: ty)
        
        return path
    }
    
    /// Translates this path translated by `v`
    func translate<FP: CGFloatPair>(_ v: FP)
    {
        translate(tx: v[0], ty: v[1])
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path translated by `tx` and `ty`
    func translated<FP: CGFloatPair>(_ v: FP) -> UIBezierPath
    {
        return translated(tx: v[0], ty: v[1])
    }
}
