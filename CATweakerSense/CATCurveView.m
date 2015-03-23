//
//  CATCurveView.m
//  CATweaker
//
//  Created by X on 2015-03-21.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import "CATCurveView.h"

#define MARGIN 18

@implementation CATDragDotOnCurveView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    int margin = 3;
    if (_mouseDown) {
        margin = 2;
    }
    [[NSGraphicsContext currentContext] saveGraphicsState];
    NSShadow *shadow = [[NSShadow alloc] init];
    if (_mouseDown) {
        [shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.2]];
        [shadow setShadowOffset:NSMakeSize(0, -2)];
        [shadow setShadowBlurRadius:2];
    }
    else{
        [shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.4]];
        [shadow setShadowOffset:NSMakeSize(0, -1)];
        [shadow setShadowBlurRadius:1];
    }
    [shadow set];
    NSBezierPath *dot = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(self.bounds, margin, margin)];
    [[NSColor grayColor] setFill];
    [dot fill];
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    
    dot = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(self.bounds, margin+1, margin+1)];
    [[NSColor colorWithDeviceWhite:1 alpha:1] setFill];
    [dot fill];
}

@end

@implementation CATCurveView
{
    NSTrackingArea *trackingArea;
    
    CATDragDotOnCurveView *draggingTargetDot;
    NSRect targetDotStartingFrame;
    NSPoint mouseDownStartingPoint;
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (trackingArea){
        [self removeTrackingArea:trackingArea];
        trackingArea=nil;
    }
    
    NSTrackingAreaOptions options = NSTrackingMouseMoved | NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        [self updateTrackingAreas];
        
        dot1 = [[CATDragDotOnCurveView alloc] initWithFrame:NSMakeRect(VIEW_WIDTH*0.3, VIEW_WIDTH*0.2, 20, 20)];
        dot2 = [[CATDragDotOnCurveView alloc] initWithFrame:NSMakeRect(VIEW_WIDTH*0.7, VIEW_WIDTH*0.6, 20, 20)];
        
        [self addSubview:dot1];
        [self addSubview:dot2];
    }
    return self;
}

/*
 * point1 return the first control point for Bezier path
 * This point contain the value (0~1.0, 0~1.0) rather than actural pixel point of dot1
 */
- (NSPoint)controlPoint1;
{
    return NSMakePoint(fabs(dot1.frame.origin.x-[self _begPoint].x)/fabs([self _begPoint].x-[self _endPoint].x), fabs(dot1.frame.origin.y-[self _begPoint].y)/fabs([self _begPoint].y-[self _endPoint].y));
}

/*
 * point1 return the second control point for Bezier path
 * This point contain the value (0~1.0, 0~1.0) rather than actural pixel point of dot2
 */
- (NSPoint)controlPoint2;
{
    return NSMakePoint(fabs(dot2.frame.origin.x-[self _begPoint].x)/fabs([self _begPoint].x-[self _endPoint].x), fabs(dot2.frame.origin.y-[self _begPoint].y)/fabs([self _begPoint].y-[self _endPoint].y));
}

#pragma mark -

/*
 * begPoint return left-bottom corner point
 * This is the start point of our Bezier path
 */
- (NSPoint)_begPoint
{
    return NSMakePoint(MARGIN, MARGIN);
}

/*
 * begPoint return right-top corner point
 * This is the end point of our Bezier path
 */
- (NSPoint)_endPoint
{
    return NSMakePoint(NSMaxX(self.bounds)-MARGIN, NSMaxY(self.bounds)-MARGIN);
}

- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    // draw background and border
    //[[NSColor colorWithDeviceWhite:1 alpha:1] setFill];
    //NSRectFill(self.bounds);
    
    NSPoint point1 = NSMakePoint(NSMidX(dot1.frame), NSMidY(dot1.frame));
    NSPoint point2 = NSMakePoint(NSMidX(dot2.frame), NSMidY(dot2.frame));
    NSPoint begPoint = [self _begPoint];
    NSPoint endPoint = [self _endPoint];
    
    int lineWidth = 1;
    
    // draw y-axis
    [[NSColor lightGrayColor] setStroke];
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(begPoint.x, begPoint.y-VIEW_WIDTH*0.05)];
    [line lineToPoint:NSMakePoint(begPoint.x, endPoint.y)];
    [line setLineCapStyle:NSSquareLineCapStyle];
    [line setLineWidth:2];
    [line stroke];
    
    // draw x-axis
    line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(begPoint.x-VIEW_WIDTH*0.05, begPoint.y)];
    [line lineToPoint:NSMakePoint(endPoint.x, begPoint.y)];
    [line setLineCapStyle:NSSquareLineCapStyle];
    [line setLineWidth:2];
    [line stroke];
    
    // draw a line from start point to the first control point
    [[NSColor grayColor] setStroke];
    NSBezierPath *p1 = [NSBezierPath bezierPath];
    [p1 moveToPoint:begPoint];
    [p1 lineToPoint:point1];
    [p1 setLineCapStyle:NSSquareLineCapStyle];
    [p1 setLineWidth:lineWidth];
    [p1 stroke];
    
    // draw a line from end point to the second control point
    NSBezierPath *p2 = [NSBezierPath bezierPath];
    [p2 moveToPoint:endPoint];
    [p2 lineToPoint:point2];
    [p2 setLineCapStyle:NSSquareLineCapStyle];
    [p2 setLineWidth:lineWidth];
    [p2 stroke];

    
    // draw our sweet Bezier path in blue color
    [[NSColor colorWithCalibratedRed:0.321 green:0.470 blue:0.684 alpha:1.000] setStroke];
    NSBezierPath *curve = [NSBezierPath bezierPath];
    [curve setLineWidth:2];
    [curve moveToPoint:begPoint];
    [curve curveToPoint:endPoint controlPoint1:point1 controlPoint2:point2];
    [curve stroke];
}

#pragma mark - Mouse Event

- (NSView *)_myHitTest:(NSPoint)aPoint
{
    for (NSView *subView in [self subviews]) {
        if (![subView isHidden] && NSPointInRect(aPoint, subView.frame))
            return subView;
    }
    return nil;
}

/*
 * limit drag point into rect
 */
- (NSPoint)_restrictPoint:(NSPoint)point
{
    int x = targetDotStartingFrame.origin.x+(point.x-mouseDownStartingPoint.x);
    if (x<0) {
        x=0;
    }
    if (x>NSMaxX(self.bounds)-VIEW_WIDTH*0.05) {
        x=NSMaxX(self.bounds)-VIEW_WIDTH*0.05;
    }
    int y = targetDotStartingFrame.origin.y+(point.y-mouseDownStartingPoint.y);
    if (y<0) {
        y=0;
    }
    if (y>NSMaxY(self.bounds)-VIEW_WIDTH*0.05) {
        y=NSMaxY(self.bounds)-VIEW_WIDTH*0.05;
    }
    return NSMakePoint(x, y);
}

- (void)mouseDown:(NSEvent *)theEvent
{
    draggingTargetDot = nil;
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSView *v = [self _myHitTest:point];
    if ([v isKindOfClass:[CATDragDotOnCurveView class]]) {
        draggingTargetDot = (CATDragDotOnCurveView*)v;
        draggingTargetDot.mouseDown = YES;
        mouseDownStartingPoint = point;
        targetDotStartingFrame = draggingTargetDot.frame;
        [draggingTargetDot setNeedsDisplay:YES];
        [self setNeedsDisplay:YES];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (draggingTargetDot) {
        
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        point = [self _restrictPoint:point];
     
        draggingTargetDot.mouseDown = NO;
        [draggingTargetDot setFrameOrigin:point];
        [draggingTargetDot setNeedsDisplay:YES];

        // redraw chart
        [self setNeedsDisplay:YES];
        
        // post notification for generating function
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangedNotification" object:nil];
        
        // register undo method
        [self _storeLastPoint:[NSString stringWithFormat:@"%d|%@", draggingTargetDot==dot1?1:2, NSStringFromPoint(targetDotStartingFrame.origin)]];
   
        draggingTargetDot = nil;
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if(draggingTargetDot){
        
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        point = [self _restrictPoint:point];
        
        [draggingTargetDot setFrameOrigin:point];
        //redraw chart
        [self setNeedsDisplay:YES];
        
        // post notification for generating function
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
    }
}

#pragma mark - undo management

- (void)_restoreLastPoint:(NSString*)lastPointStr
{
    NSAssert([NSThread mainThread]==[NSThread currentThread], @"main thread only");
  
    NSString *target = [lastPointStr substringToIndex:1];
    lastPointStr = [lastPointStr substringFromIndex:2];
    NSPoint lastPoint = NSPointFromString(lastPointStr);
    if ([target isEqualTo:@"1"]) {
        [dot1 setFrameOrigin:lastPoint];
    }
    else if ([target isEqualTo:@"2"]) {
        [dot2 setFrameOrigin:lastPoint];
    }
    
    // redraw chart
    [self setNeedsDisplay:YES];
    
    // post notification for generating function
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangedNotification" object:nil];
}

- (void)_storeLastPoint:(NSString*)lastPointStr
{
    [[self undoManager] registerUndoWithTarget:self
                                      selector:@selector(_restoreLastPoint:)
                                        object:lastPointStr];
}


@end
