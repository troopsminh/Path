//
//  UIBezierPath+Align.swift
//  Path
//
//  Created by Christian Otkjær on 20/05/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import Arithmetic

// MARK: - Align

extension UIBezierPath
{
    func alignIn(rect: CGRect, alignment: Alignment = AlignmentCenter)
    {
        let pathBounds = bounds
        
        let width = (rect.width - pathBounds.width) / 2
        let height = (rect.height - pathBounds.height) / 2
        
//        let deltaW = (-width, width) ◊ alignment.x
        let deltaW = (width, -width) ◊ alignment.x
//        let deltaH = (-height, height) ◊ alignment.y
        let deltaH = (height, -height) ◊ alignment.y
        
        let tx = rect.midX - (pathBounds.midX + deltaW )
        let ty = rect.midY - (pathBounds.midY + deltaH )
        
        translate(tx: tx, ty: ty)
    }
    
    func alignIn(rect:CGRect, contentMode: UIViewContentMode)
    {
        let pathBounds = bounds
        
        switch contentMode
        {
        case .ScaleAspectFit:
            let factor = min(rect.height/pathBounds.height, rect.width/pathBounds.width)
            scale(sx:factor, sy:factor)
            
        case .ScaleAspectFill:
            let factor = max(rect.height/pathBounds.height, rect.width/pathBounds.width)
            scale(sx: factor, sy:factor)
            
        case .ScaleToFill:
            scale(sx: rect.width/pathBounds.width, sy: rect.height/pathBounds.height)

        default: break
            //NOOP
        }
        
        alignIn(rect, alignment: contentMode.alignment)
    }
}

