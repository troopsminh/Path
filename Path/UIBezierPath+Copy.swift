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
        self.init(cgPath: path.cgPath)
        lineWidth = path.lineWidth
        lineCapStyle = path.lineCapStyle
        lineJoinStyle = path.lineJoinStyle
        
    }
    
    /// Returns a copy of this path, using `NSObject.copy()`
    public func copyPath() -> UIBezierPath
    {
        guard let path = copy() as? UIBezierPath else { fatalError("\(self).copy() is not a UIBezierPath") }
        
        return path
    }
}
