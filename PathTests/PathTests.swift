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
        path.move(to: CGPoint(x: 10, y: 10))
        path.addLine(to: CGPoint(x: 20, y: 20))
        path.addQuadCurve(to: CGPoint(x: 100, y: 10), controlPoint: CGPoint(x: 50, y: 100))
        path.addCurve(to: CGPoint(x: 50, y: 0), controlPoint1: CGPoint(x: 75, y: 100), controlPoint2: CGPoint(x: 10, y: -100))
        path.close()
    }
    
    func test_elements()
    {
        let oval = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
        
        XCTAssertGreaterThan(oval.elements.count, 2)
        
        XCTAssertEqual(path.elements.count, 5)
        
        XCTAssertEqual(path.elements[1], PathElement.addLineToPoint(CGPoint(x: 20, y: 20)))
    }
    
    func test_init_elements()
    {
        XCTAssertEqual(UIBezierPath(elements: []).elements.count, 0)
        
        XCTAssertEqual(UIBezierPath(elements: path.elements).elements.count, 5)

        XCTAssertEqual(UIBezierPath(elements: [PathElement.moveToPoint(CGPoint.zero)]).elements.count, 1)
    }

    func test_image()
    {
        path.lineWidth = 25
        path.setLineDash([2,2])
        path.lineJoinStyle = .round
        
        var image = path.image(strokeColor: UIColor.red, fillColor: UIColor.white, backgroundColor: nil)
        
        XCTAssertNotNil(image)
        
        let circle = UIBezierPath(ovalIn: CGRect(size: CGSize(500)))
        circle.lineWidth = 25
        
        image = circle.image(strokeColor: UIColor.red, fillColor: UIColor.yellow, backgroundColor: UIColor.white)
        
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
    
    func test_scale_toFit()
    {
        path.lineWidth = 10
        path.scale(toFit: CGSize(1000))
        
        XCTAssertLessThanOrEqual(path.bounds.width, 1000)
        XCTAssertLessThanOrEqual(path.bounds.height, 1000)
    }
    
    func test_transformToFit()
    {
        let rect = CGRect(x: 100, y: 10, width: 50, height: 400)
        
        path.transform(toFit: rect)
        
        path.append(UIBezierPath(rect: rect))
        
        XCTAssertLessThanOrEqual(path.bounds.width, 50)
        XCTAssertLessThanOrEqual(path.bounds.height, 400)
    }
    
    func test_transformToFit_top()
    {
        let rect = CGRect(x: 100, y: 10, width: 50, height: 400)
        
        path.transform(toFit: rect, alignment: CGPoint(0.5, 1))
        
        path.append(UIBezierPath(rect: rect))
        
        XCTAssertLessThanOrEqual(path.bounds.width, 50)
        XCTAssertLessThanOrEqual(path.bounds.height, 400)
    }
    
    func test_alignment()
    {
        let rect = CGRect(x: 100, y: 10, width: 50, height: 400)
        
        let radius : CGFloat = 20
        let circle = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true)
        
        circle.align(in: rect)
        
        XCTAssertEqual(circle.bounds.width, 40)
        XCTAssertEqual(circle.bounds.height, 40)
        XCTAssertEqual(circle.bounds.center, rect.center)//CGPoint(125, 210))
        
        circle.align(in:rect, contentMode: UIViewContentMode.bottom)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.maxY - radius))
        
        circle.align(in:rect, contentMode: UIViewContentMode.bottomRight)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.maxX - radius, rect.maxY - radius))
        
        circle.align(in:rect, contentMode: UIViewContentMode.bottomLeft)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.minX + radius, rect.maxY - radius))
        
        circle.align(in:rect, contentMode: UIViewContentMode.top)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.minY + radius))
        
        circle.align(in:rect, contentMode: UIViewContentMode.topRight)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.maxX - radius, rect.minY + radius))
        
        circle.align(in:rect, contentMode: UIViewContentMode.topLeft)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.minX + radius, rect.minY + radius))
        
        circle.align(in:rect, contentMode: UIViewContentMode.right)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.maxX - radius, rect.midY))
        
        circle.align(in:rect, contentMode: UIViewContentMode.left)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.minX + radius, rect.midY))
        
        circle.align(in:rect, contentMode: UIViewContentMode.center)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        
        circle.align(in:rect, contentMode: UIViewContentMode.scaleAspectFit)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        XCTAssertEqual(circle.bounds.size, CGSize(50, 50))

        circle.align(in:rect, contentMode: UIViewContentMode.scaleAspectFill)
        XCTAssertEqual(circle.bounds.center, CGPoint(rect.midX, rect.midY))
        XCTAssertEqual(circle.bounds.size, CGSize(400, 400))
        
        circle.align(in:rect, contentMode: UIViewContentMode.scaleToFill)
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
        
        p1.move(to: point)
        XCTAssert(p1 != p2)
        
        p2.move(to: point)
        XCTAssert(p1 == p2)
        
        let p3 = UIBezierPath()
        
        p3.move(to: CGPoint(x: 10, y: 10))
        p3.addLine(to: CGPoint(x: 20, y: 20))
        p3.addQuadCurve(to: CGPoint(x: 100, y: 10), controlPoint: CGPoint(x: 50, y: 100))
        p3.addCurve(to: CGPoint(x: 50, y: 0), controlPoint1: CGPoint(x: 75, y: 100), controlPoint2: CGPoint(x: 10, y: -100))
        p3.close()
        
        XCTAssertEqual(p3, path)
        
        
        let p4 = UIBezierPath(path: p3)
        
        XCTAssertEqual(p3, p4)
        XCTAssertFalse(p3 === p4)
    }

    func test_triangle()
    {
        let t1 = UIBezierPath(triangleWithTopAt: .zero, height: 100, topAngle: .pi/3)
        let t2 = UIBezierPath(triangleWithTopAt: .zero, height: 100, topAngle: .pi/3)
        
        XCTAssertEqual(t2, t1)
        
        XCTAssertTrue(t1.bounds.center != .zero)
    }
    
    func test_gear()
    {
        let g1 = UIBezierPath(gearWithCenter: .zero, innerRadius: 100, outerRadius: 150, teeth: 6)
        let g2 = UIBezierPath(gearWithCenter: .zero, innerRadius: 100, outerRadius: 150, teeth: 7)
        
        XCTAssertNotEqual(g1, g2)
        
        XCTAssertNotEqual(g1.bounds, .zero)
    }

    func test_reload()
    {
        let r0 = UIBezierPath(reloadSymbolWithCenter: .zero, radius: 100, arrows: 0)
        let r1 = UIBezierPath(reloadSymbolWithCenter: .zero, radius: 100, arrows: 1)
        let r2 = UIBezierPath(reloadSymbolWithCenter: .zero, radius: 100, arrows: 2)
        let r3 = UIBezierPath(reloadSymbolWithCenter: .zero, radius: 100, arrows: 3)
        let r4 = UIBezierPath(reloadSymbolWithCenter: .zero, radius: 100, arrows: 4)

        XCTAssertEqual(r0, UIBezierPath())

        XCTAssertNotEqual(r2, r0)
        XCTAssertNotEqual(r2, r1)
        XCTAssertNotEqual(r2, r3)
        XCTAssertNotEqual(r2, r4)
        XCTAssertNotEqual(r1, r3)
        XCTAssertNotEqual(r1, r4)
        XCTAssertNotEqual(r3, r4)
        
        XCTAssertNotEqual(r2.bounds, .zero)
    }

}
