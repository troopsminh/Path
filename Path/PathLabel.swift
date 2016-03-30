//
//  PathLabel.swift
//  Path
//
//  Created by Christian Otkjær on 30/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

public class PathLabel: UILabel
{
    // MARK: - Path
    
    public var path: UIBezierPath?
        {
        didSet
        {
            updateTextPath()
            
            setNeedsDisplay()
        }
    }
    
    // MARK: - Init
    
    override public init(frame: CGRect)
    {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public func awakeFromNib()
    {
        super.awakeFromNib()
        setup()
    }
    
    func setup()
    {
        //TODO
    }

    // MARK: - Size
    
    override public func sizeThatFits(size: CGSize) -> CGSize
    {
        return textPath.bounds.size
    }

    // MARK: - Interface Builder
    
    public override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
    public override func intrinsicContentSize() -> CGSize
    {
        return displayPath.approximateBoundsForFont(font).size
    }
    
    // MARK: - Display Path
    
    private var displayPath : UIBezierPath
        {
            if let path = self.path
            {
                return path
            }
            
            let path = UIBezierPath()
            
            path.moveToPoint(bounds.centerLeft)
            path.addLineToPoint(bounds.centerRight)
            
            return path
    }
    
    private var textPath = UIBezierPath()
    
    func updateTextPath()
    {
        textPath = displayPath.warp(text, font: font, textAlignment: textAlignment)
        
        bounds.size = displayPath.approximateBoundsForFont(font).size
        superview?.setNeedsLayout()
        
        setNeedsDisplay()
    }
    
//    // MARK: - Image
//    
//    private let imageView = UIImageView()
//    
    override public func drawRect(rect: CGRect)
    {
        //TODO: Alpha checks on colors

        if let bgColor = backgroundColor
        {
            let bg = UIBezierPath(rect: bounds)
            bgColor.setFill()
            bg.fill()
        }
    
        textColor.setFill()

        textPath.alignIn(bounds)
        
        textPath.fill()
      
        
        if let renderPath = path
        {
            UIColor.grayColor().setStroke()
            renderPath.alignIn(bounds)
            renderPath.stroke()
        }
        
        
//        textPath.translated(bounds.center).fill()
    }
}
