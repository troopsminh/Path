//
//  UIBezierPath+Dots.swift
//  Path
//
//  Created by Christian Otkjær on 04/11/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

// MARK: - Dots

extension UIBezierPath
{
    public func strokeWithDots()
    {
        let path = copyPath()
        
        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = .round
        
        path.stroke()
    }
}
