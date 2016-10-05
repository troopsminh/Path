//
//  PathLabel.swift
//  Path
//
//  Created by Christian Otkjær on 30/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

open class PathLabel: UILabel
{
    // MARK: - Path
    
    open var path: UIBezierPath?
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
    
    override open func awakeFromNib()
    {
        super.awakeFromNib()
        setup()
    }
    
    func setup()
    {
        //TODO
    }

    // MARK: - Size
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize
    {
        return textPath.bounds.size
    }

    // MARK: - Interface Builder
    
    open override func prepareForInterfaceBuilder()
    {
        super.prepareForInterfaceBuilder()
        
        setup()
    }
    
    open override var intrinsicContentSize : CGSize
    {
        return displayPath.approximateBoundsForFont(font).size
    }
    
    // MARK: - Display Path
    
    fileprivate var displayPath : UIBezierPath
        {
            if let path = self.path
            {
                return path
            }
            
            let path = UIBezierPath()
            
            path.move(to: bounds.centerLeft)
            path.addLine(to: bounds.centerRight)
            
            return path
    }
    
    fileprivate var textPath = UIBezierPath()
    
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
    override open func draw(_ rect: CGRect)
    {
        //TODO: Alpha checks on colors

        if let bgColor = backgroundColor
        {
            let bg = UIBezierPath(rect: bounds)
            bgColor.setFill()
            bg.fill()
        }
    
        textColor.setFill()

        textPath.align(in: bounds)
        
        textPath.fill()
      
        
        if let renderPath = path
        {
            UIColor.gray.setStroke()
            renderPath.align(in: bounds)
            renderPath.stroke()
        }
        
        
//        textPath.translated(bounds.center).fill()
    }
}
