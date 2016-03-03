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
        
        let bounds = CGRect(center: rect.center, size: CGSize(widthAndHeight: rect.minWidthHeight))
        
        moveToPoint(bounds.topCenter)
        addLineToPoint(bounds.bottomCenter)
        
        moveToPoint(bounds.centerLeft)
        addLineToPoint(bounds.centerRight)
        
    }
    
    public convenience init(plusWithCenter center: CGPoint = CGPointZero, radius: CGFloat)
    {
        self.init(plusInRect: CGRect(center: center, size: CGSize(widthAndHeight: radius * 2)))
    }
}
