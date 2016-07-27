//
//  UIBezierPath+Copy.swift
//  Path
//
//  Created by Christian Otkjær on 27/07/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Copy

extension UIBezierPath
{
    /// Initializ as a copy of `path`
    public convenience init(path: UIBezierPath)
    {
        self.init(CGPath: path.CGPath)
    }
    
    /// Returns a copy of this path, using `NSObject.copy()`
    public func copyPath() -> UIBezierPath
    {
        return copy() as! UIBezierPath
    }
}
