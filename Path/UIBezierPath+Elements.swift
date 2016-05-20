//
//  UIBezierPath+Elements.swift
//  Path
//
//  Created by Christian Otkjær on 02/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//


extension UIBezierPath
{
    var elements: [PathElement]
        {
            var pathElements = [PathElement]()
            withUnsafeMutablePointer(&pathElements)
                { elementsPointer in
                    CGPathApply(CGPath, elementsPointer)
                        { (userInfo, nextElementPointer) in
                            let nextElement = PathElement(element: nextElementPointer.memory)
                            let elementsPointer = UnsafeMutablePointer<[PathElement]>(userInfo)
                            elementsPointer.memory.append(nextElement)
                    }
            }
            return pathElements
    }
}

//extension UIBezierPath : SequenceType
//{
//    public func generate() -> AnyGenerator<PathElement>
//    {
//        return anyGenerator(elements.generate())
//    }
//}

//extension UIBezierPath : CustomDebugStringConvertible
//{
//    public override var debugDescription: String
//        {
//            let cgPath = self.CGPath
//            let bounds = CGPathGetPathBoundingBox(cgPath)
//            let controlPointBounds = CGPathGetBoundingBox(cgPath)
//            
//            return (["\(self.dynamicType)", "bounds: \(bounds)", "control-point bounds: \(controlPointBounds)"] + elements.map({ $0.debugDescription })).joinWithSeparator(",\n     ")
//    }
//}

//MARK: - Init Elements

public extension UIBezierPath
{
    convenience init(elements: [PathElement])
    {
        self.init()
        
        for element in elements
        {
            switch element
            {
            case let .MoveToPoint(point):
                moveToPoint(point)
                
            case .CloseSubpath:
                closePath()
                
            case let .AddLineToPoint(point):
                addLineToPoint(point)
                
            case let .AddQuadCurveToPoint(ctrlPoint, endPoint):
                addQuadCurveToPoint(endPoint, controlPoint: ctrlPoint)
                
            case let .AddCurveToPoint(ctrlPoint1, ctrlPoint2, endPoint):
                addCurveToPoint(endPoint, controlPoint1: ctrlPoint1, controlPoint2: ctrlPoint2)
            }
        }
    }
}