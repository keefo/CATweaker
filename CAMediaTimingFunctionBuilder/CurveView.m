//
//  CurveView.m
//  CAMediaTimingFunctionBuilder
//
//  Created by X on 2015-03-21.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import "CurveView.h"

#define MARGIN 40

@implementation DragDotOnCurveView

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

@interface CurveView()
{
    DragDotOnCurveView *mouseDownDot;
    NSPoint mouseDownPoint;
    NSRect mouseDownFrame;
    NSTrackingArea *trackingArea;
}
@end

@implementation CurveView

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

- (void)awakeFromNib
{
    [self updateTrackingAreas];
    dot1 = [[DragDotOnCurveView alloc] initWithFrame:NSMakeRect(30, 30, 20, 20)];
    dot2 = [[DragDotOnCurveView alloc] initWithFrame:NSMakeRect(200, 200, 20, 20)];
    
    [dot1 setFrameOrigin:NSPointFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"dot1Origin"])];
    [dot2 setFrameOrigin:NSPointFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"dot2Origin"])];
    
    if (!NSPointInRect(dot1.frame.origin, self.bounds)) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dot1Origin"];
        [dot1 setFrameOrigin:NSPointFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"dot1Origin"])];
    }
    
    if (!NSPointInRect(dot2.frame.origin, self.bounds)) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dot2Origin"];
        [dot2 setFrameOrigin:NSPointFromString([[NSUserDefaults standardUserDefaults] objectForKey:@"dot2Origin"])];
    }
    
    [self addSubview:dot1];
    [self addSubview:dot2];
}

- (NSPoint)begPoint
{
    return NSMakePoint(MARGIN, MARGIN);
}

- (NSPoint)endPoint
{
    return NSMakePoint(NSMaxX(self.bounds)-MARGIN, NSMaxY(self.bounds)-MARGIN);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor grayColor] setFill];
    NSRectFill(NSInsetRect(self.bounds, 0, 0));
    [[NSColor colorWithDeviceWhite:0.97 alpha:1] setFill];
    NSRectFill(NSInsetRect(self.bounds, 1, 1));
    
    NSPoint point1 = NSMakePoint(NSMidX(dot1.frame), NSMidY(dot1.frame));
    NSPoint point2 = NSMakePoint(NSMidX(dot2.frame), NSMidY(dot2.frame));
    NSPoint begPoint = [self begPoint];
    NSPoint endPoint = [self endPoint];
    
    int lineWidth = 2;
    
    [[NSColor lightGrayColor] setStroke];
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(begPoint.x, begPoint.y-20)];
    [line lineToPoint:NSMakePoint(begPoint.x, endPoint.y)];
    [line setLineCapStyle:NSSquareLineCapStyle];
    [line setLineWidth:3];
    [line stroke];
    
    line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(begPoint.x-20, begPoint.y)];
    [line lineToPoint:NSMakePoint(endPoint.x, begPoint.y)];
    [line setLineCapStyle:NSSquareLineCapStyle];
    [line setLineWidth:3];
    [line stroke];
    
    [[NSColor grayColor] setStroke];
    NSBezierPath *p1 = [NSBezierPath bezierPath];
    [p1 moveToPoint:begPoint];
    [p1 lineToPoint:point1];
    [p1 setLineCapStyle:NSSquareLineCapStyle];
    [p1 setLineWidth:lineWidth];
    [p1 stroke];
    
    NSBezierPath *p2 = [NSBezierPath bezierPath];
    [p2 moveToPoint:endPoint];
    [p2 lineToPoint:point2];
    [p2 setLineCapStyle:NSSquareLineCapStyle];
    [p2 setLineWidth:lineWidth];
    [p2 stroke];

    [[NSColor colorWithCalibratedRed:0.321 green:0.470 blue:0.684 alpha:1.000] setStroke];
    
    NSBezierPath *curve = [NSBezierPath bezierPath];
    [curve setLineWidth:3];
    [curve moveToPoint:begPoint];
    [curve curveToPoint:endPoint controlPoint1:point1 controlPoint2:point2];
    [curve stroke];
}

- (NSPoint)point1;
{
    return NSMakePoint(fabs(dot1.frame.origin.x-[self begPoint].x)/fabs([self begPoint].x-[self endPoint].x), fabs(dot1.frame.origin.y-[self begPoint].y)/fabs([self begPoint].y-[self endPoint].y));
}

- (NSPoint)point2;
{
    return NSMakePoint(fabs(dot2.frame.origin.x-[self begPoint].x)/fabs([self begPoint].x-[self endPoint].x), fabs(dot2.frame.origin.y-[self begPoint].y)/fabs([self begPoint].y-[self endPoint].y));
}

#pragma mark - Mouse Event

- (NSView *)myHitTest:(NSPoint)aPoint
{
    for (NSView *subView in [self subviews]) {
        if (![subView isHidden] && NSPointInRect(aPoint, subView.frame))
            return subView;
    }
    
    return nil;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    mouseDownDot = nil;
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSView *v = [self myHitTest:point];
    if ([v isKindOfClass:[DragDotOnCurveView class]]) {
        mouseDownDot = (DragDotOnCurveView*)v;
        mouseDownDot.mouseDown = YES;
        mouseDownPoint = point;
        mouseDownFrame = mouseDownDot.frame;
        [mouseDownDot setNeedsDisplay:YES];
        [self setNeedsDisplay:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
    }
}

- (NSPoint)restrictPoint:(NSPoint)point
{
    int x = mouseDownFrame.origin.x+(point.x-mouseDownPoint.x);
    if (x<0) {
        x=0;
    }
    if (x>NSMaxX(self.bounds)-20) {
        x=NSMaxX(self.bounds)-20;
    }
    int y = mouseDownFrame.origin.y+(point.y-mouseDownPoint.y);
    if (y<0) {
        y=0;
    }
    if (y>NSMaxY(self.bounds)-20) {
        y=NSMaxY(self.bounds)-20;
    }
    return NSMakePoint(x, y);
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (mouseDownDot) {
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        point = [self restrictPoint:point];
        
        mouseDownDot.mouseDown = NO;
        mouseDownDot.frame = NSMakeRect(point.x , point.y, mouseDownFrame.size.width, mouseDownFrame.size.height);
        [mouseDownDot setNeedsDisplay:YES];
        if (mouseDownDot==dot1) {
            [[NSUserDefaults standardUserDefaults] setObject:NSStringFromPoint(dot1.frame.origin) forKey:@"dot1Origin"];
        }
        else if (mouseDownDot==dot2) {
            [[NSUserDefaults standardUserDefaults] setObject:NSStringFromPoint(dot2.frame.origin) forKey:@"dot2Origin"];
        }
        mouseDownDot = nil;
        [self setNeedsDisplay:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
    }
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    if(mouseDownDot){
        NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        point = [self restrictPoint:point];
        
        mouseDownDot.frame = NSMakeRect(point.x , point.y, mouseDownFrame.size.width, mouseDownFrame.size.height);
        [self setNeedsDisplay:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PointChangeNotification" object:nil];
    }
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    NSLog(@"mouseMoved");
}


@end
