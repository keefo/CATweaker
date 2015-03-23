//
//  NSBezierPath.m
//  iYY
//
//  Created by yidi on 02/07/10.
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

/*
- (CGPathRef)quartzPath
{
    int i, numElements;
    
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = (int)[self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
        
        for (i = 0; i < numElements; i++)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
        
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);
        
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    return immutablePath;
}

 - (CGMutablePathRef)mutableQuartzPath;
{
    NSInteger i, numElements;
    
    // If there are elements to draw, create a CGMutablePathRef and draw.
    
    numElements = [self elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint            points[3];
        
        for (i = 0; i < numElements; ++i)
        {
            switch ([self elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    break;
                    
                default:
                    break;
            }
        }
        
        // the caller is responsible for releasing this ref when done
        
        return path;
    }
    
    return nil;
}
 */


/*
+ (CGPathRef)CGPathForRect:(CGRect)rect radius:(CGFloat)radius
{
	CGMutablePathRef retPath = CGPathCreateMutable();
    
	CGRect innerRect = CGRectInset(rect, radius, radius);
    
	CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
	CGFloat outside_right = rect.origin.x + rect.size.width;
	CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
	CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
	CGFloat inside_top = innerRect.origin.y;
	CGFloat outside_top = rect.origin.y;
	CGFloat outside_left = rect.origin.x;
    
	CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
	CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
	CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
	CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
	CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
	CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
	CGPathCloseSubpath(retPath);

#if  __has_feature(objc_arc)
	return retPath;
#else
	return retPath;
#endif

}
*/


@end



