//
//  CurveView.h
//  CAMediaTimingFunctionBuilder
//
//  Created by X on 2015-03-21.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DragDotOnCurveView : NSView
@property(assign, nonatomic) BOOL mouseDown;

@end

@interface CurveView : NSView
{
    DragDotOnCurveView *dot1;
    DragDotOnCurveView *dot2;
}

- (NSPoint)controlPoint1;
- (NSPoint)controlPoint2;

@end
