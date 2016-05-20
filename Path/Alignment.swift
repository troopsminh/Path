//
//  Alignment.swift
//  Path
//
//  Created by Christian Otkjær on 20/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Foundation

/// Top-left is (0,0), bottom-right is (1,1)
public typealias Alignment = CGPoint

internal let AlignmentCenter = Alignment(x: 0.5, y: 0.5)
// MARK: - Alignment

extension UIViewContentMode
{
    internal var alignment : Alignment
    {
        switch self
        {
        case .ScaleAspectFit:
            return AlignmentCenter
            
        case .ScaleAspectFill:
            return AlignmentCenter
            
        case .ScaleToFill:
            return AlignmentCenter
            
        case .Bottom:
            return CGPoint(0.5, 1.0)
            
        case .BottomLeft:
            return CGPoint(0.0, 1.0)
            
        case .BottomRight:
            return CGPoint(1.0, 1.0)
            
        case .Top:
            return CGPoint(0.5, 0.0)
            
        case .TopLeft:
            return CGPoint(0.0, 0.0)
            
        case .TopRight:
            return CGPoint(1.0, 0.0)
            
        case .Left:
            return CGPoint(0.0, 0.5)
            
        case .Right:
            return CGPoint(1.0, 0.5)
            
        case .Center:
            return AlignmentCenter
            
        default:
            return AlignmentCenter
        }
    }
}

