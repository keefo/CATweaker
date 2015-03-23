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
}
@property (nonatomic, retain) NSTextView *textView;
@property (nonatomic, retain) NSRegularExpression *timingFunctionWithNameRegex;
@property (nonatomic, retain) NSRegularExpression *timingFunctionWithControlPointsRegex;

@end
