//
//  PathLabel+Animate.swift
//  Path
//
//  Created by Christian Otkjær on 05/10/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Animation

// MARK: - Animate

extension PathLabel
{
    // MARK: - Text
    
    public func animateText(to text: String?, duration: Double)
    {
        let newPath = displayPath.warp(text: text, font: font) 

        newPath.align(in: bounds)
        
        textPathLayer.animate(pathTo: newPath.cgPath, duration: duration)
    }
}
