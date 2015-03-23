//
//  CATweakerHelper.h
//  CATweaker
//
//  Created by X on 2015-03-22.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@class CATFrameView;

@interface CATweakerHelper : NSObject
{
    CATFrameView *catFrameView;
    NSRegularExpression *_timingFunctionWithNameRegex;
    NSRegularExpression *_timingFunctionWithControlPointsRegex;
}
@property (nonatomic, strong) NSTextView *textView;

@end
