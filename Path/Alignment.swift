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
        case .scaleAspectFit:
            return AlignmentCenter
            
        case .scaleAspectFill:
            return AlignmentCenter
            
        case .scaleToFill:
            return AlignmentCenter
            
        case .bottom:
            return CGPoint(0.5, 1.0)
            
        case .bottomLeft:
            return CGPoint(0.0, 1.0)
            
        case .bottomRight:
            return CGPoint(1.0, 1.0)
            
        case .top:
            return CGPoint(0.5, 0.0)
            
        case .topLeft:
            return CGPoint(0.0, 0.0)
            
        case .topRight:
            return CGPoint(1.0, 0.0)
            
        case .left:
            return CGPoint(0.0, 0.5)
            
        case .right:
            return CGPoint(1.0, 0.5)
            
        case .center:
            return AlignmentCenter
            
        default:
            return AlignmentCenter
        }
    }
}

