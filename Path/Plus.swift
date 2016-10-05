//
//  Plus.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

// MARK: - Plus

extension UIBezierPath
{
    public convenience init(plusInRect rect: CGRect)
    {
        self.init()
        
        let bounds = CGRect(origin: rect.center, size: CGSize(rect.minWidthHeight))
        
        move(to: bounds.topCenter)
        addLine(to: bounds.bottomCenter)
        
        move(to: bounds.centerLeft)
        addLine(to: bounds.centerRight)
        
    }
    
    public convenience init(plusWithCenter center: CGPoint = CGPoint.zero, radius: CGFloat)
    {
        self.init(plusInRect: CGRect(origin: center, size: CGSize(radius * 2)))
    }
}
