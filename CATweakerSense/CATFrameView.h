//
//  CATFrameView.h
//  CATweaker
//
//  Created by X on 2015-03-22.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CurveViewController : NSViewController

@end

@interface CATFrameView : NSView
@property(assign) id helper;
@property(readonly) int buttonHeight;
@property(nonatomic, retain) CAMediaTimingFunction *timingFunction;
@property(nonatomic, retain) NSColor *strokeColor;

@end
