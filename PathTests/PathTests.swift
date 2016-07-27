//
//  PathTests.swift
//  PathTests
//
//  Created by Christian Otkjær on 01/03/16.
//  Copyright © 2016 Christian Otkjær. All rights reserved.
//

import XCTest
@testable import Path

class PathTests: XCTestCase
{
    let path = UIBezierPath()
    
    override func setUp()
    {
        path.moveToPoint(CGPoint(x: 10, y: 10))
        path.addLineToPoint(CGPoint(x: 20, y: 20))
        path.addQuadCurveToPoint(CGPoint(x: 100, y: 10), controlPoint: CGPoint(x: 50, y: 100))
        path.addCurveToPoint(CGPoint(x: 50, y: 0), controlPoint1: CGPoint(x: 75, y: 100), controlPoint2: CGPoint(x: 10, y: -100))
        path.closePath()
    }
    
    func test_elements()
    {
        let oval = UIBezierPath(ovalInRect: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100)))
        
        XCTAssertGreaterThan(oval.elements.count, 2)
        
        XCTAssertEqual(path.elements.count, 5)
        
        XCTAssertEqual(path.elements[1], PathElement.AddLineToPoint(CGPoint(x: 20, y: 20)))
    }
    
    func test_init_elements()
    {
        XCTAssertEqual(UIBezierPath(elements: []).elements.count, 0)
        
        XCTAssertEqual(UIBezierPath(elements: path.elements).elements.count, 5)

        XCTAssertEqual(UIBezierPath(elements: [PathElement.MoveToPoint(CGPointZero)]).elements.count, 1)
    }

    func test_image()
    {
        path.lineWidth = 25
        path.setLineDash([2,2])
        path.lineJoinStyle = .Round
        
        var image = path.image(strokeColor: UIColor.redColor(), fillColor: UIColor.whiteColor(), backgroundColor: nil)
        
        XCTAssertNotNil(image)
        
        let circle = UIBezierPath(ovalInRect: CGRect(size: CGSize(500)))
        circle.lineWidth = 25
        
        image = circle.image(strokeColor: UIColor.redColor(), fillColor: UIColor.yellowColor(), backgroundColor: UIColor.whiteColor())
        
        XCTAssertNotNil(image)
        
    }
    
    func test_stroke_bounds()
    {
        let rect = UIBezierPath(rect: CGRect(size: CGSize(100, 200)))

        rect.lineWidth = 20

        XCTAssertEqual(rect.bounds.minY, 0)
        XCTAssertEqual(rect.bounds.maxY, 200)
        XCTAssertEqual(rect.bounds.minX, 0)
        XCTAssertEqual(rect.bounds.maxX, 100)
        
        let strokeBounds = rect.strokeBounds
        
        XCTAssertEqual(strokeBounds.minY, -10)
        XCTAssertEqual(strokeBounds.maxY, 210)
        XCTAssertEqual(strokeBounds.minX, -10)
        XCTAssertEqual(strokeBounds.maxX, 110)
    }
    
    func test_scaleToFit()
    {
        path.lineWidth = 10
        path.scaleToFit(CGSize(1000))
        
        XCTAssertLessThanOrEqual(path.bounds.width, 1000)
        XCTAssertLessThanOrEqual(path.bounds.height, 1000)
    }
    
    func test_transformToFit()
    {
        let rect = CGRect(x: 100, y: 10, width: 50, height: 400)
        
        path.transformToFit(rect)
        
        path.appendPath(UIBezierPath(rect: rect))
        
        XCTAssertLessThanOrEqual(path.bounds.width, 50)
        XCTAssertLessThanOrEqual(path.bounds.height, 400)
    }
    
    func test_transformToFit_top()
    {
        let rect = CGRect(x: 100, y: 10, width: 50, height: 400)
        
        path.transformToFit(rect, alignment: CGPoint(0.5, 1))
        
        path.appendPath(UIBezierPath(rect: rect))
        
        XCTAssertLessThanOrEqual(path.bounds.width, 50)
        XCTAssertLessThanOrEqual(path.bounds.height, 400)
    }
    
    func test_alignment()
    {
        let rect = CGRect(x: 100, y: 10, width: 50, height: 400)
        
        let radius : CGFloat = 20
        let circle = UIBezierPath(arcCenter: CGPointZero, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        circle.alignIn(rect)
        
        XCTAssertEqual(circle.bounds.width, 40)
        XCTAssertEqual(circle.bounds.height, 40)
        XCTAssertEqual(circle.bounds.center, rect.center)//CGPoint(125, 210))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.Bottom)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.maxY - radius))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.BottomRight)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.maxX - radius, rect.maxY - radius))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.BottomLeft)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.minX + radius, rect.maxY - radius))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.Top)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.minY + radius))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.TopRight)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.maxX - radius, rect.minY + radius))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.TopLeft)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.minX + radius, rect.minY + radius))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.Right)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.maxX - radius, rect.midY))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.Left)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.minX + radius, rect.midY))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.Center)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.ScaleAspectFit)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        XCTAssertEqual(circle.bounds.size, CGSize(50, 50))

        circle.alignIn(rect, contentMode: UIViewContentMode.ScaleAspectFill)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        XCTAssertEqual(circle.bounds.size, CGSize(400, 400))
        
        circle.alignIn(rect, contentMode: UIViewContentMode.ScaleToFill)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        XCTAssertEqual(circle.bounds.size, CGSize(50, 400))
    }
    
    func test_equality()
    {
        let p1 = UIBezierPath()
        let p2 = UIBezierPath()
        
        XCTAssert(p1 == p1)
        XCTAssert(p2 == p2)
        XCTAssert(p1 == p2)
        XCTAssertFalse(p1 === p2)
        
        let point = CGPoint(3,4)
        
        p1.moveToPoint(point)
        XCTAssert(p1 != p2)
        
        p2.moveToPoint(point)
        XCTAssert(p1 == p2)
        
        let p3 = UIBezierPath()
        
        p3.moveToPoint(CGPoint(x: 10, y: 10))
        p3.addLineToPoint(CGPoint(x: 20, y: 20))
        p3.addQuadCurveToPoint(CGPoint(x: 100, y: 10), controlPoint: CGPoint(x: 50, y: 100))
        p3.addCurveToPoint(CGPoint(x: 50, y: 0), controlPoint1: CGPoint(x: 75, y: 100), controlPoint2: CGPoint(x: 10, y: -100))
        p3.closePath()
        
        XCTAssertEqual(p3, path)
        
        
        let p4 = UIBezierPath(path: p3)
        
        XCTAssertEqual(p3, p4)
        XCTAssertFalse(p3 === p4)
    }

}
