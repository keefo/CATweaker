//
//  NSBezierPath.h
//  iYY
//
//  Created by Keefo on 02/07/10.
//  Copyright 2010 Beyondcow. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface NSBezierPath  (LXExtension)
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)bezierPathWithTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)bezierPathWithBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)bezierPathWithRightBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)appendBezierPathWithLeftBottomAndRightTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;

- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
- (void)appendBezierPathWithTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;
- (void)appendBezierPathWithBottomRoundedRect:(NSRect)rect cornerRadius:(float)radius;
- (void)appendBezierPathWithLeftRoundedRect:(NSRect)rect cornerRadius:(float)radius;
- (void)appendBezierPathWithRightRoundedRect:(NSRect)rect cornerRadius:(float)radius;
- (void)appendBezierPathWithLeftBottomAndRightTopRoundedRect:(NSRect)rect cornerRadius:(float)radius;

- (void)strokeInside;
- (void)strokeInsideWithinRect:(NSRect)clipRect;

@end
