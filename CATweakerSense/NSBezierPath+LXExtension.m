//
//  NSBezierPath.m
//  iYY
//
//  Created by Keefo on 02/07/10.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import "NSBezierPath+LXExtension.h"


@implementation NSBezierPath (LXExtension)

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithRoundedRect:rect cornerRadius:radius];
    return result;
}

+ (NSBezierPath *)bezierPathWithTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithTopRoundedRect:rect cornerRadius:radius];
    return result;
}

+ (NSBezierPath *)bezierPathWithBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithBottomRoundedRect:rect cornerRadius:radius];
    return result;	
}

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithLeftRoundedRect:rect cornerRadius:radius];
    return result;	
}

+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithRightRoundedRect:rect cornerRadius:radius];
    return result;	
}

+ (NSBezierPath *)bezierPathWithRightBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithRightBottomRoundedRect:rect cornerRadius:radius];
    return result;
}

+ (NSBezierPath *)appendBezierPathWithLeftBottomAndRightTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (NSIsEmptyRect(rect)) {
        return nil;
    }
	NSBezierPath *result = [NSBezierPath bezierPath];
    [result appendBezierPathWithLeftBottomAndRightTopRoundedRect:rect cornerRadius:radius];
    return result;	
}

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			// Clamp radius to be no larger than half the rect's width or height.
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			//clampedRadius=radius;
			//float clampedRadius = radius;
			
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			
			[self moveToPoint:NSMakePoint(NSMinX(rect)+clampedRadius, NSMaxY(rect))];
			[self appendBezierPathWithArcFromPoint:topLeft     toPoint:rect.origin radius:clampedRadius];
			[self appendBezierPathWithArcFromPoint:rect.origin toPoint:bottomRight radius:clampedRadius];
			[self appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight    radius:clampedRadius];
			[self appendBezierPathWithArcFromPoint:topRight    toPoint:topLeft     radius:clampedRadius];
			[self closePath];
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}


- (void)appendBezierPathWithTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			// Clamp radius to be no larger than half the rect's width or height.
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			//clampedRadius=radius;
			
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			NSPoint topMid = NSMakePoint(NSMidX(rect), NSMaxY(rect));
			
			[self moveToPoint:topMid];
			[self appendBezierPathWithArcFromPoint:topLeft     toPoint:rect.origin radius:clampedRadius];
			[self appendBezierPathWithArcFromPoint:rect.origin toPoint:bottomRight radius:0];
			[self appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight    radius:0];
			[self appendBezierPathWithArcFromPoint:topRight    toPoint:topLeft     radius:clampedRadius];
			[self closePath];
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}


- (void)appendBezierPathWithBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			//clampedRadius=radius;
			
			NSPoint bottomMid = NSMakePoint(NSMidX(rect), NSMinY(rect));
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			NSPoint bottomLeft = NSMakePoint(NSMinX(rect), NSMinY(rect));
			
			[self moveToPoint:topLeft];
			[self appendBezierPathWithArcFromPoint:bottomLeft toPoint:bottomMid radius: clampedRadius];
			[self appendBezierPathWithArcFromPoint:bottomRight toPoint:topRight radius: clampedRadius];
			[self appendBezierPathWithArcFromPoint:topRight toPoint:topLeft radius: 0];
			[self closePath];
			
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}

- (void)appendBezierPathWithLeftRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			
			NSPoint bottomMid = NSMakePoint(NSMidX(rect), NSMinY(rect));
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			NSPoint bottomLeft = NSMakePoint(NSMinX(rect), NSMinY(rect));
			
			[self moveToPoint:topRight];
			[self appendBezierPathWithArcFromPoint:topLeft toPoint:bottomLeft radius: clampedRadius];
			[self appendBezierPathWithArcFromPoint:bottomLeft toPoint:bottomMid radius: clampedRadius];
			[self lineToPoint:bottomRight];
			[self closePath];
			
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}


- (void)appendBezierPathWithRightRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			
			NSPoint bottomMid = NSMakePoint(NSMidX(rect), NSMinY(rect));
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			NSPoint bottomLeft = NSMakePoint(NSMinX(rect), NSMinY(rect));
			
			[self moveToPoint:topLeft];
			[self appendBezierPathWithArcFromPoint:topRight toPoint:bottomRight radius: clampedRadius];
			[self appendBezierPathWithArcFromPoint:bottomRight toPoint:bottomMid radius: clampedRadius];
			[self lineToPoint:bottomLeft];
			[self closePath];
			
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}


- (void)appendBezierPathWithRightBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
    if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			
			NSPoint bottomMid = NSMakePoint(NSMidX(rect), NSMinY(rect));
			NSPoint topLeft = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topRight = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomRight = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			NSPoint bottomLeft = NSMakePoint(NSMinX(rect), NSMinY(rect));
			
			[self moveToPoint:topLeft];
			[self lineToPoint:topRight];
			[self appendBezierPathWithArcFromPoint:bottomRight toPoint:bottomMid radius:clampedRadius];
			[self lineToPoint:bottomLeft];
			[self closePath];
			
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}


- (void)appendBezierPathWithLeftBottomAndRightTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;
{
	if (!NSIsEmptyRect(rect)) {
		if (radius > 0.0) {
			float clampedRadius = MIN(radius, 0.5 * MIN(rect.size.width, rect.size.height));
			
			NSPoint bottomMid = NSMakePoint(NSMidX(rect), NSMinY(rect));
			NSPoint topRight = NSMakePoint(NSMinX(rect), NSMaxY(rect));
			NSPoint topLeft = NSMakePoint(NSMaxX(rect), NSMaxY(rect));
			NSPoint bottomLeft = NSMakePoint(NSMaxX(rect), NSMinY(rect));
			NSPoint bottomRight = NSMakePoint(NSMinX(rect), NSMinY(rect));
			
			[self moveToPoint:bottomMid];
			[self appendBezierPathWithArcFromPoint:bottomLeft toPoint:topLeft radius: clampedRadius];
			[self lineToPoint:topLeft];
			[self appendBezierPathWithArcFromPoint:topRight toPoint:bottomRight radius: clampedRadius];
			[self lineToPoint:bottomRight];
			[self closePath];
			
		} else {
			// When radius == 0.0, this degenerates to the simple case of a plain rectangle.
			[self appendBezierPathWithRect:rect];
		}
    }
}

- (void)strokeInside;
{
    /* Stroke within path using no additional clipping rectangle. */
    [self strokeInsideWithinRect:NSZeroRect];
}

- (void)strokeInsideWithinRect:(NSRect)clipRect;
{
    NSGraphicsContext *thisContext = [NSGraphicsContext currentContext];
    float lineWidth = [self lineWidth];
    
    /* Save the current graphics context. */
    [thisContext saveGraphicsState];
    
    /* Double the stroke width, since -stroke centers strokes on paths. */
    [self setLineWidth:(lineWidth * 2.0)];
    
    /* Clip drawing to this path; draw nothing outwith the path. */
    [self addClip];
    
    /* Further clip drawing to clipRect, usually the view's frame. */
    if (clipRect.size.width > 0.0 && clipRect.size.height > 0.0) {
        [NSBezierPath clipRect:clipRect];
    }
    
    /* Stroke the path. */
    [self stroke];
    
    /* Restore the previous graphics context. */
    [thisContext restoreGraphicsState];
    [self setLineWidth:lineWidth];
}


@end



