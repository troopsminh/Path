//
//  UIBezierPath+Elements.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

extension UIBezierPath
{
    private func pathElements() -> [PathElement]
    {
        var pathElements = [PathElement]()
        
        withUnsafeMutablePointer(to: &pathElements)
        { elementsPointer in
            cgPath.apply(info: elementsPointer)
            { (userInfo, nextElementPointer) in
                let nextElement = PathElement(element: nextElementPointer.pointee)
                
                let elementsPointer = userInfo?.assumingMemoryBound(to: [PathElement].self)
                
                elementsPointer?.pointee.append(nextElement)
            }
        }
        
        return pathElements
    }
    
    var elements: [PathElement]
    {
        return self.pathElements()
    }
}

//MARK: - Init Elements

public extension UIBezierPath
{
    convenience init<S: Sequence>(elements: S) where S.Iterator.Element == CGPathElement
    {
        self.init()
        
        for element in elements
        {
            switch element.type
            {
            case .moveToPoint:
                self.move(to: element.points[0])
            case .addLineToPoint:
                self.addLine(to: element.points[0])
            case .addQuadCurveToPoint:
                self.addQuadCurve(to: element.points[0], controlPoint: element.points[1])
            case .addCurveToPoint:
                self.addCurve(to: element.points[0], controlPoint1: element.points[1], controlPoint2: element.points[2])
            case .closeSubpath:
                self.close()
            }
        }
    }
    
    convenience init(elements: [PathElement])
    {
        self.init()
        
        for element in elements
        {
            switch element
            {
            case let .moveToPoint(point):
                move(to: point)
                
            case .closeSubpath:
                close()
                
            case let .addLineToPoint(point):
                addLine(to: point)
                
            case let .addQuadCurveToPoint(ctrlPoint, endPoint):
                addQuadCurve(to: endPoint, controlPoint: ctrlPoint)
                
            case let .addCurveToPoint(ctrlPoint1, ctrlPoint2, endPoint):
                addCurve(to: endPoint, controlPoint1: ctrlPoint1, controlPoint2: ctrlPoint2)
            }
        }
    }
}
