//
//  CATCurveView.h
//  CATweaker
//
//  Created by X on 2015-03-21.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define VIEW_WIDTH  180

@interface CATDragDotOnCurveView : NSView
@property(assign, nonatomic) BOOL mouseDown;
@end

@interface CATCurveView : NSView
{
    CATDragDotOnCurveView *dot1;
    CATDragDotOnCurveView *dot2;
}
@property(assign) id delegate;

- (NSPoint)controlPoint1;
- (NSPoint)controlPoint2;

- (void)setTimingFunction:(CAMediaTimingFunction*)fun;

@end
