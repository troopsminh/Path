//
//  UIBezierPath+Transform.swift
//  Path
//
//  Created by Christian Otkjær on 12/02/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Flipping

public extension UIBezierPath
{
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
    func flip(vertically: Bool, horizontally: Bool)
    {
        if vertically || horizontally
        {
            scale(sx: horizontally ? -1 : 1, sy: vertically ? -1 : 1)
        }
    }
    
    /// Returns a new `UIBezierPath` that is a copy of this path flipped around none, one, or both axis
    func flipped(vertically: Bool, horizontally: Bool) -> UIBezierPath
    {
        let path = UIBezierPath(path:self)
        
        path.flip(vertically: vertically, horizontally: horizontally)
        
        return path
    }

}

