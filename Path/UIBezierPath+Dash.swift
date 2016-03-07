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
    func setLineDash(pattern: Array<CGFloat> = [], phase: CGFloat = 0)
    {
        var p = pattern.count > 0 ? pattern : [lineWidth, lineWidth]
        
        setLineDash(&p, count: pattern.count, phase: phase)
    }
}
