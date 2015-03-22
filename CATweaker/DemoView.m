//
//  DemoView.m
//  CATweaker
//
//  Created by X on 2015-03-22.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import "DemoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DemoView
{
    NSTrackingArea *trackingArea;
    BOOL mouseIn;
    CALayer *ball;
    CAMediaTimingFunction *currentTimingFunction;
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if (trackingArea){
        [self removeTrackingArea:trackingArea];
        trackingArea=nil;
    }
    
    NSTrackingAreaOptions options = NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways;
    trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
    [self addTrackingArea:trackingArea];
}


- (void)awakeFromNib
{
    [self updateTrackingAreas];
    [self setLayer:[CALayer layer]];
    [self setWantsLayer:YES];
    self.layer.backgroundColor = [[NSColor colorWithCalibratedWhite:0.908 alpha:1.000] CGColor];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[NSColor grayColor] CGColor];
    
    ball = [CALayer layer];
    ball.frame = CGRectMake(NSMidX(self.bounds), NSMidY(self.bounds), 16, 16);
    ball.cornerRadius = 8;
    ball.backgroundColor = [[NSColor colorWithCalibratedRed:0.786 green:0.272 blue:0.221 alpha:1.000] CGColor];
    
    ball.shadowColor = [[NSColor blackColor] CGColor];
    ball.shadowRadius = 1;
    ball.shadowOffset = CGSizeMake(0, -1);
    ball.shadowOpacity = 0.1;
    
    [self.layer addSublayer:ball];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}

- (void)animationWithTimeFunction:(CAMediaTimingFunction*)timingFunction;
{
    [ball removeAllAnimations];
    
    currentTimingFunction = timingFunction;
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    ball.frame = CGRectMake(NSMinX(self.bounds)+10, NSMinY(self.bounds)+10, 16, 16);
    [CATransaction commit];
    
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFromValue:[NSValue valueWithPoint:ball.frame.origin]];
    [animation setToValue:[NSValue valueWithPoint:CGPointMake(NSMaxX(self.bounds)-20, NSMaxY(self.bounds)-20)]];
    [animation setTimingFunction:currentTimingFunction];
    if (mouseIn) {
        [animation setDuration:5.0];
    }
    else{
        [animation setDuration:1.0];
    }
    [animation setRepeatCount:INT16_MAX];
    
    [ball addAnimation:animation forKey:@"position"];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    mouseIn = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    [self animationWithTimeFunction:currentTimingFunction];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    mouseIn = NO;
    self.layer.backgroundColor = [[NSColor colorWithCalibratedWhite:0.908 alpha:1.000] CGColor];
    [self animationWithTimeFunction:currentTimingFunction];
}

@end
