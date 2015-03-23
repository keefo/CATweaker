//
//  CATFrameView.h
//  CATweaker
//
//  Created by X on 2015-03-22.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CATFrameView : NSView
@property(readonly) int buttonHeight;
@property(nonatomic, retain) CAMediaTimingFunction *timingFunction;
@property(nonatomic, retain) NSColor *strokeColor;

@end
