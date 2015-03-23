//
//  CATFrameView.m
//  CATweaker
//
//  Created by X on 2015-03-22.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CATFrameView.h"
#import "NSBezierPath+LXExtension.h"

@implementation CATFrameView

- (id)initWithFrame:(NSRect)frameRect
{
    if (self=[super initWithFrame:frameRect]) {
        _buttonHeight = 17;
        _strokeColor = [NSColor blackColor];
    }
    return self;
}

- (void)setTimingFunction:(CAMediaTimingFunction *)timingFunction
{
    if (_timingFunction != timingFunction) {
        _timingFunction = timingFunction;
        [self setNeedsDisplay:YES];
    }
}

- (void)setStrokeColor:(NSColor *)strokeColor
{
    if (strokeColor != _strokeColor) {
        _strokeColor = strokeColor;
        [self setNeedsDisplay:YES];
    }
}

- (NSRect)_buttonRect
{
    NSRect rect = NSInsetRect(self.bounds, 0.5, 0.5);
    rect.size.height-=_buttonHeight;
    return NSMakeRect(NSMaxX(rect)-_buttonHeight, NSMaxY(rect), _buttonHeight, _buttonHeight);
}

- (NSPoint)_convertToButtonPoint:(float[2])p
{
    NSRect r = [self _buttonRect];
    r = NSInsetRect(r, 1, 1);
    return NSMakePoint(r.origin.x + r.size.width*p[0], r.origin.y + r.size.height*p[1]);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [_strokeColor setStroke];
    [[NSColor whiteColor] setFill];
    
    NSRect rect = NSInsetRect(self.bounds, 0.5, 0.5);
    rect.size.height-=_buttonHeight;
    [NSBezierPath strokeRect:rect];
    
    NSBezierPath *btn = [NSBezierPath bezierPathWithTopRoundedRect:[self _buttonRect] cornerRadius:0];
    [btn setLineWidth:1];
    [btn setLineCapStyle:NSSquareLineCapStyle];
    [btn fill];
    [btn stroke];
    
    if (_timingFunction) {
        float p0[2],p1[2],p2[2],p3[2];
        
        NSBezierPath *curve = [NSBezierPath bezierPath];
        [curve setLineWidth:1];
        
        [_timingFunction getControlPointAtIndex:0 values:p0];
        [_timingFunction getControlPointAtIndex:1 values:p1];
        [_timingFunction getControlPointAtIndex:2 values:p2];
        [_timingFunction getControlPointAtIndex:3 values:p3];
        
        [curve moveToPoint:[self _convertToButtonPoint:p0]];
        
        [curve curveToPoint:[self _convertToButtonPoint:p3]
              controlPoint1:[self _convertToButtonPoint:p1]
              controlPoint2:[self _convertToButtonPoint:p2]];
        
        [[NSColor blueColor] setStroke];
        [curve stroke];
    }
}


- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint loc   = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if (NSPointInRect(loc, [self _buttonRect])) {
        NSLog(@"mouseUp");
        
    }
    else{
        [super mouseDown:theEvent];
    }
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint loc   = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    if (NSPointInRect(loc, [self _buttonRect])) {
        NSLog(@"mouseUp");
    }
    else{
        [super mouseUp:theEvent];
    }
}

@end
