//
//  PathElement.swift
//  Path
//
//  Created by Christian Otkjær on 01/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import UIKit

/// A Swiftified representation of a `CGPathElement`
///
/// Simpler and safer than `CGPathElement` because it doesn’t use a
/// C array for the associated points.
public enum PathElement
{
    case moveToPoint(CGPoint)
    case addLineToPoint(CGPoint)
    case addQuadCurveToPoint(CGPoint, CGPoint)
    case addCurveToPoint(CGPoint, CGPoint, CGPoint)
    case closeSubpath
    
    init(element: CGPathElement)
    {
        switch element.type
        {
        case .moveToPoint:
            self = .moveToPoint(element.points[0])
        case .addLineToPoint:
            self = .addLineToPoint(element.points[0])
        case .addQuadCurveToPoint:
            self = .addQuadCurveToPoint(element.points[0], element.points[1])
        case .addCurveToPoint:
            self = .addCurveToPoint(element.points[0], element.points[1], element.points[2])
        case .closeSubpath:
            self = .closeSubpath
        }
    }
}

extension PathElement : CustomDebugStringConvertible
{
    public var debugDescription: String
        {
            switch self
            {
            case let .moveToPoint(point):
                return "\(point.x) \(point.y) moveto"
            case let .addLineToPoint(point):
                return "\(point.x) \(point.y) lineto"
            case let .addQuadCurveToPoint(point1, point2):
                return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) quadcurveto"
            case let .addCurveToPoint(point1, point2, point3):
                return "\(point1.x) \(point1.y) \(point2.x) \(point2.y) \(point3.x) \(point3.y) curveto"
            case .closeSubpath:
                return "closepath"
            }
    }
}

extension PathElement : Equatable { }

public func == (lhs: PathElement, rhs: PathElement) -> Bool
{
    switch(lhs, rhs)
    {
    case let (.moveToPoint(l), .moveToPoint(r)):
        return l == r
    case let (.addLineToPoint(l), .addLineToPoint(r)):
        return l == r
    case let (.addQuadCurveToPoint(l1, l2), .addQuadCurveToPoint(r1, r2)):
        return l1 == r1 && l2 == r2
    case let (.addCurveToPoint(l1, l2, l3), .addCurveToPoint(r1, r2, r3)):
        return l1 == r1 && l2 == r2 && l3 == r3
    case (.closeSubpath, .closeSubpath):
        return true
    case (_, _):
        return false
    }
}
