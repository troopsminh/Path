//
//  UIBezierPath+Dash.swift
//  Path
//
//  Created by Christian Otkjær on 07/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

// MARK: - Dash

public extension UIBezierPath
{
    /**
     Sets the line-stroking pattern for the path.
     
    - parameter pattern : An array of floating point values that contains the lengths (measured in points) of the line segments and gaps in the pattern. The values in the array alternate, starting with the first line segment length, followed by the first gap length, followed by the second line segment length, and so on.
    
    - parameter phase: The offset at which to start drawing the pattern, measured in points along the dashed-line pattern. For example, a phase value of 6 for the pattern 5-2-3-2 would cause drawing to begin in the middle of the first gap.
     */
    func setLineDash(_ pattern: Array<CGFloat> = [], phase: CGFloat = 0)
    {
        var p = pattern.count > 0 ? pattern : [lineWidth, lineWidth]
        
        setLineDash(&p, count: pattern.count, phase: phase)
    }
}
