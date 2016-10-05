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

open class GraphicsPath
{
    var elements = Array<PathElement>()
    
    init(elements: [PathElement])
    {
        self.elements = elements
    }
    
    convenience init(cgPath: CGPath)
    {
        self.init(uiBezierPath: UIBezierPath(cgPath: cgPath))
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
    
    lazy var frame : CGRect = { return self.uiBezierPath.cgPath.boundingBox }()
    
    // MARK: - Cubic Bezier Curves
    
    func cubicBezierCurves() -> [CubicBezierCurve]
    {
        var curves = Array<CubicBezierCurve>()
        
        var subPathBeginPoint = CGPoint.zero
        var beginPoint = CGPoint.zero
        
        elements.forEach { (element) -> () in
            
            switch element
            {
            case .moveToPoint(let point):
                
                subPathBeginPoint = point
                beginPoint = point
                
                
            case .addLineToPoint(let endPoint):
               
                let ctrlPoint1 = (beginPoint * 2 + endPoint) / 3
                let ctrlPoint2 = (beginPoint + endPoint * 2) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .addQuadCurveToPoint(let ctrlPoint, let endPoint):
                
                // A quadratic Bezier curve can be always represented by a cubic one by applying the degree elevation algorithm. The resulting cubic representation will share its anchor points with the original quadratic, while the control points will be at 2/3 of the quadratic handle segments:
                let ctrlPoint1 = (ctrlPoint * 2 + beginPoint) / 3
                let ctrlPoint2 = (ctrlPoint * 2 + endPoint) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
            case .addCurveToPoint(let ctrlPoint1, let ctrlPoint2, let endPoint):
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = endPoint
                
                
            case .closeSubpath:
                
                let endPoint = subPathBeginPoint
                
                let ctrlPoint1 = (beginPoint * 2 + endPoint) / 3
                let ctrlPoint2 = (beginPoint + endPoint * 2) / 3
                
                curves.append(CubicBezierCurve(p0: beginPoint, p1: ctrlPoint1, p2: ctrlPoint2, p3: endPoint))
                
                beginPoint = CGPoint.zero
                subPathBeginPoint = CGPoint.zero
                
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
        
        let elementsDescriptions = elements.enumerated().map({ "\($0) : \($1.debugDescription)" })
        
        return "\npath\n" + elementsDescriptions.joined(separator: "\n")
    }
}

//MARK: - Draw

extension GraphicsPath
{
    func stroke(withColor color: UIColor = UIColor.black, lineWidth: CGFloat = 1, inContext: CGContext? = nil)
    {
        guard let context = inContext ?? UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        
        // Flip the context coordinates in iOS only.
        context.translateBy(x: 0, y: frame.size.height)
        context.scaleBy(x: 1, y: -1)
        
        context.translateBy(x: -lineWidth, y: -lineWidth)
        
        context.addPath(uiBezierPath.cgPath)
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        
        context.strokePath()
        
        context.restoreGState()
    }
    
    func fill(withColor color: UIColor = UIColor.black, inContext: CGContext? = nil)
    {
        guard let context = inContext ?? UIGraphicsGetCurrentContext() else { return }
        
        context.saveGState()
        
        // Flip the context coordinates in iOS only.
        context.translateBy(x: 0, y: frame.size.height)
        context.scaleBy(x: 1, y: -1)
        
        context.addPath(uiBezierPath.cgPath)
        
        context.setFillColor(color.cgColor)
        
        context.fillPath()
        
        context.restoreGState()
    }
}
