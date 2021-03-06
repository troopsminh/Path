//
//  CGPath.swift
//  Path
//
//  Created by Christian Otkjær on 26/11/15.
//  Copyright © 2015 Christian Otkjær. All rights reserved.
//

import UIKit

// MARK: - Contains

extension CGPath
{
//    public func contains(_ point: CGPoint) -> Bool
//    {
//        return CGPathContainsPoint(self, nil, point, false)
//    }
}

//MARK: - Elements

extension CGPathElement : CustomDebugStringConvertible
{
    public var debugDescription : String
        {
            switch (type)
            {
            case .moveToPoint:
                return "move(\(points[0]))"
                
            case .addLineToPoint:
                return "line(\(points[0]))"
                
            case .addQuadCurveToPoint:
                return "quadCurve(\(points[0]), \(points[1]))"
                
            case .addCurveToPoint:
                return "curve(\(points[0]), \(points[1]), \(points[2]))"
                
            case .closeSubpath:
                return "close()"
            }
    }
}

public extension CGPath
{
    fileprivate typealias PathApplier = @convention(block) (UnsafePointer<CGPathElement>) -> ()
    // Note: You must declare PathApplier as @convention(block), because
    // if you don't, you get "fatal error: can't unsafeBitCast between
    // types of different sizes" at runtime, on Mac OS X at least.
    
    fileprivate func pathApply(_ path: CGPath!, block: PathApplier)
    {
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let block = unsafeBitCast(info, to: PathApplier.self)
            block(element)
        }
        
        path.apply(info: unsafeBitCast(block, to: UnsafeMutableRawPointer.self), function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
    }
    
    public var debugDescription : String
        {
            var elementDescriptions = Array<String>()
            
            pathApply(self) { element in
                
                elementDescriptions.append(element.pointee.debugDescription)
                
//                switch (element.memory.type) {
//                case .MoveToPoint:
//                    print("move(\(element.memory.points[0]))")
//                case .AddLineToPoint:
//                    print("line(\(element.memory.points[0]))")
//                case .AddQuadCurveToPoint:
//                    print("quadCurve(\(element.memory.points[0]), \(element.memory.points[1]))")
//                case .AddCurveToPoint:
//                    print("curve(\(element.memory.points[0]), \(element.memory.points[1]), \(element.memory.points[2]))")
//                case .CloseSubpath:
//                    print("close()")
//                }
            }
            
            return elementDescriptions.joined(separator: "\n")
    }
    
    public func cgPathElements() -> Array<CGPathElement>
    {
        var cgPathElements = Array<CGPathElement>()
        
        withUnsafeMutablePointer(to: &cgPathElements) { cgPathElementsPointer in
            
            pathApply(self) { elementPointer in
                
                cgPathElementsPointer.pointee.append(elementPointer.pointee)
                
                //                let element = elementPointer.memory
                //
                //                switch element.type
                //                {
                //                case CGPathElementType.MoveToPoint:
                //                    debugPrint("move(\(element.points[0]))")
                //                case .AddLineToPoint:
                //                    debugPrint("line(\(element.points[0]))")
                //                case .AddQuadCurveToPoint:
                //                    debugPrint("quadCurve(\(element.points[0]), \(element.points[1]))")
                //                case .AddCurveToPoint:
                //                    debugPrint("curve(\(element.points[0]), \(element.points[1]), \(element.points[2]))")
                //                case .CloseSubpath:
                //                    debugPrint("close()")
                //                }
                //
                //                cgPathElementsPointer.memory.append(element)
            }
        }
        
        return cgPathElements
    }
    
    func enumerateElements(_ closure : (CGPathElement) -> ())
    {
        pathApply(self) { (elementPointer: UnsafePointer<CGPathElement>) -> Void in
            
            closure(elementPointer.pointee)
            
        }
    }
}


// MARK: - Font

public extension CTRun
{
    var font : CTFont
        {
            let key = Unmanaged.passUnretained(kCTFontAttributeName).toOpaque()
            
            let attributes = CTRunGetAttributes(self)
            
            let value = CFDictionaryGetValue(attributes, key)
            
            let font:CTFont = unsafeBitCast(value, to: CTFont.self)
            
            return font
    }
    
    var glyphCount : Int
        {
            return CTRunGetGlyphCount(self)
    }
    
    func getGlyphs(_ range: CFRange, _ buffer: UnsafeMutablePointer<CGGlyph>) -> Array<CGGlyph>
    {
        var glyphs = Array<CGGlyph>(repeating: CGGlyph(), count: range.length)
        
        CTRunGetGlyphs(self, range, &glyphs)
        
        return glyphs
    }
}

// MARK: - Glyphs

extension CTFont
{
    func pathForGlyph(_ glyph: CGGlyph, matrix: UnsafePointer<CGAffineTransform>? = nil) -> CGPath?
    {
        return CTFontCreatePathForGlyph(self, glyph, matrix)
    }
}


// MARK: - Text

// MARK: Single Line String Path

public func CGPathCreateSingleLineStringWithAttributedString(_ attrString: NSAttributedString) -> CGPath
{
    let letters = CGMutablePath()
    
    let line = CTLineCreateWithAttributedString(attrString)
    
    let anyArray = CTLineGetGlyphRuns(line) as [AnyObject]
    
    if let runArray = anyArray as? Array<CTRun>
    {
        for run in runArray
        {
            // for each glyph in run
            
            for runGlyphIndex in 0..<run.glyphCount //CTRunGetGlyphCount(run)
            {
                // get glyph and position
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph : CGGlyph = 0
                var position : CGPoint = CGPoint.zero
                
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                
                CTRunGetPositions(run, thisGlyphRange, &position)
                
                // Get PATH of outline
                
                if let letter = CTFontCreatePathForGlyph(run.font, glyph, nil)
                {
                    let t = CGAffineTransform(translationX: position.x, y: position.y)
                    
                    letters.addPath(letter, transform: t)
                }

                
//                CGPathAddPath(letters, &t, letter)
            }
        }
    }
    
    return letters.copy() ?? letters
}

/*
// MARK: - Multiple Line String Path

CGPathRef CGPathCreateMultilineStringWithAttributedString(NSAttributedString *attrString, CGFloat maxWidth, CGFloat maxHeight)
{

CGMutablePathRef letters = CGPathCreateMutable();

CGRect bounds = CGRectMake(0, 0, maxWidth, maxHeight);

CGPathRef pathRef = CGPathCreateWithRect(bounds, NULL);

CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(attrString));
CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef, NULL);

CFArrayRef lines = CTFrameGetLines(frame);

CGPoint *points = malloc(sizeof(CGPoint) * CFArrayGetCount(lines));

CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), points);

NSInteger numLines = CFArrayGetCount(lines);
// for each LINE
for (CFIndex lineIndex = 0; lineIndex < numLines; lineIndex++)
{
CTLineRef lineRef = CFArrayGetValueAtIndex(lines, lineIndex);

CFRange r = CTLineGetStringRange(lineRef);

NSParagraphStyle *paragraphStyle = [attrString attribute:NSParagraphStyleAttributeName atIndex:r.location effectiveRange:NULL];
NSTextAlignment alignment = paragraphStyle.alignment;


CGFloat flushFactor = 0.0;
if (alignment == NSTextAlignmentLeft) {
flushFactor = 0.0;
} else if (alignment == NSTextAlignmentCenter) {
flushFactor = 0.5;
} else if (alignment == NSTextAlignmentRight) {
flushFactor = 1.0;
}



CGFloat penOffset = CTLineGetPenOffsetForFlush(lineRef, flushFactor, maxWidth);

// create a new justified line if the alignment is justified
if (alignment == NSTextAlignmentJustified) {
lineRef = CTLineCreateJustifiedLine(lineRef, 1.0, maxWidth);
penOffset = 0;
}

CGFloat lineOffset = numLines == 1 ? 0 : maxHeight - points[lineIndex].y;

CFArrayRef runArray = CTLineGetGlyphRuns(lineRef);

// for each RUN
for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
{
// Get FONT for this run
CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);

// for each GLYPH in run
for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
{
// get Glyph & Glyph-data
CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
CGGlyph glyph;
CGPoint position;
CTRunGetGlyphs(run, thisGlyphRange, &glyph);
CTRunGetPositions(run, thisGlyphRange, &position);

position.y -= lineOffset;
position.x += penOffset;

CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
CGPathAddPath(letters, &t, letter);
CGPathRelease(letter);
}
}

// if the text is justified then release the new justified line we created.
if (alignment == NSTextAlignmentJustified) {
CFRelease(lineRef);
}
}

free(points);

CGPathRelease(pathRef);
CFRelease(frame);
CFRelease(framesetter);

CGRect pathBounds = CGPathGetBoundingBox(letters);
CGAffineTransform transform = CGAffineTransformMakeTranslation(-pathBounds.origin.x, -pathBounds.origin.y);
CGPathRef finalPath = CGPathCreateCopyByTransformingPath(letters, &transform);
CGPathRelease(letters);

return finalPath;
}
*/
