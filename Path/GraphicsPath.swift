//
//  GraphicsPath.swift
//  Path
//
//  Created by Christian Otkjær on 01/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit
import Arithmetic
import Graphics

public class GraphicsPath
{
    var elements = Array<PathElement>()
    
    init(elements: [PathElement])
    {
        self.elements = elements
    }
    
    convenience init(cgPath: CGPathRef)
    {
        self.init(uiBezierPath: UIBezierPath(CGPath: cgPath))
    }
    
    convenience init(uiBezierPath: UIBezierPath)
    {
        self.init(elements: uiBezierPath.elements)
    }
    
    convenience init(attributedString: NSAttributedString)
    {
        self.init(cgPath: CGPathCreateSingleLineStringWithAttributedString(attributedString))
    }
    
    convenience init(string: String, withFont font: UIFont)
    {
        self.init(attributedString: NSAttributedString(string: string, attributes: [NSFontAttributeName : font]))
    }
    
    // MARK: - UIBezierPath
    
    lazy var uiBezierPath : UIBezierPath =
    {
        return UIBezierPath(elements: self.elements)
        
    }()
    
    // MARK: - frame
    
    lazy var frame : CGRect = { return CGPathGetBoundingBox(self.uiBezierPath.CGPath) }()
    
    // MARK: - Cubic Bezier Curves
    
    func cubicBezierCurves() -> [CubicBezierCurve]
    {
        var curves = Array<CubicBezierCurve>()
        
        var subPathBeginPoint = CGPointZero
        var beginPoint = CGPointZero
        
        elements.forEach { (element) -> () in
            
            switch element
            {
            case .MoveToPoint(let point):
                
                subPathBeginPoint = point
                beginPoint = point
                
                
            case .AddLineToPoint(let endPoint):
               
                let ctrlPoint1 = (beginPoint * 2 + endPoint) / 3
                let ctrlPoint2 = (beginPoint + endPoint * 2) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .AddQuadCurveToPoint(let ctrlPoint, let endPoint):
                
                // A quadratic Bezier curve can be always represented by a cubic one by applying the degree elevation algorithm. The resulting cubic representation will share its anchor points with the original quadratic, while the control points will be at 2/3 of the quadratic handle segments:
                let ctrlPoint1 = (ctrlPoint * 2 + beginPoint) / 3
                let ctrlPoint2 = (ctrlPoint * 2 + endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
            case .AddCurveToPoint(let ctrlPoint1, let ctrlPoint2, let endPoint):
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .CloseSubpath:
                
                let endPoint = subPathBeginPoint
                
                let ctrlPoint1 = (beginPoint * 2 + endPoint) / 3
                let ctrlPoint2 = (beginPoint + endPoint * 2) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = CGPointZero
                subPathBeginPoint = CGPointZero
                
            }
        }
        
        return curves
    }
}

// MARK: - CustomDebugStringConvertible

extension GraphicsPath : CustomDebugStringConvertible
{
    public var debugDescription : String
        {
        
        let elementsDescriptions = elements.enumerate().map({ "\($0) : \($1.debugDescription)" })
        
        return "\npath\n" + elementsDescriptions.joinWithSeparator("\n")
    }
}

//MARK: - Draw

extension GraphicsPath
{
    func stroke(withColor color: UIColor = UIColor.blackColor(), lineWidth: CGFloat = 1, inContext: CGContextRef? = nil)
    {
        guard let context = inContext ?? UIGraphicsGetCurrentContext() else { return }
        
        CGContextSaveGState(context)
        
        // Flip the context coordinates in iOS only.
        CGContextTranslateCTM(context, 0, frame.size.height)
        CGContextScaleCTM(context, 1, -1)
        
        CGContextTranslateCTM(context, -lineWidth, -lineWidth)
        
        CGContextAddPath(context, uiBezierPath.CGPath)
        
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        CGContextSetLineWidth(context, lineWidth)
        
        CGContextStrokePath(context)
        
        CGContextRestoreGState(context)
    }
    
    func fill(withColor color: UIColor = UIColor.blackColor(), inContext: CGContextRef? = nil)
    {
        guard let context = inContext ?? UIGraphicsGetCurrentContext() else { return }
        
        CGContextSaveGState(context)
        
        // Flip the context coordinates in iOS only.
        CGContextTranslateCTM(context, 0, frame.size.height)
        CGContextScaleCTM(context, 1, -1)
        
        CGContextAddPath(context, uiBezierPath.CGPath)
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillPath(context)
        
        CGContextRestoreGState(context)
    }
}
