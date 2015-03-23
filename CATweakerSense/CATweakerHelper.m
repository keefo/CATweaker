//
//  CATweakerHelper.m
//  CATweaker
//
//  Created by X on 2015-03-22.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import "CATweakerHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "CATFrameView.h"


#define kCATweakerHelperHighlightingDisabled  @"LXCATweakerHelperHighlightingDisabled"

@implementation CATweakerHelper

#pragma mark - Plugin Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
}

- (id)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:NSApplicationDidFinishLaunchingNotification object:nil];

        _timingFunctionWithNameRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\[\\s*CAMediaTimingFunction\\s*functionWithName\\s*:\\s*(kCAMediaTimingFunctionLinear|kCAMediaTimingFunctionEaseIn|kCAMediaTimingFunctionEaseOut|kCAMediaTimingFunctionEaseInEaseOut|kCAMediaTimingFunctionDefault)\\s*\\])" options:0 error:NULL];
        
        _timingFunctionWithControlPointsRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\[\\s*CAMediaTimingFunction\\s*functionWithControlPoints\\s*:\\s*([0-9]*\\.?[0-9]*f?)\\s*(\\/\\s*[0-9]*\\.?[0-9]*f?)?\\s*:\\s*([0-9]*\\.?[0-9]*f?)\\s*(\\/\\s*[0-9]*\\.?[0-9]*f?)?\\s*:\\s*([0-9]*\\.?[0-9]*f?)\\s*(\\/\\s*[0-9]*\\.?[0-9]*f?)?\\s*:\\s*([0-9]*\\.?[0-9]*f?)\\s*(\\/\\s*[0-9]*\\.?[0-9]*f?)?\\s*\\])" options:0 error:NULL];
        
    }
    return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSMenuItem *editMenuItem = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (editMenuItem) {
        [[editMenuItem submenu] addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *toggleColorHighlightingMenuItem = [[NSMenuItem alloc] initWithTitle:@"Animation Curve Under Caret Enabled"
                                                                                 action:@selector(toggleCAT:)
                                                                          keyEquivalent:@""];
        [toggleColorHighlightingMenuItem setTarget:self];
        [[editMenuItem submenu] addItem:toggleColorHighlightingMenuItem];
        
//        NSMenuItem *colorInsertionModeItem = [[NSMenuItem alloc] initWithTitle:@"Animation Curve Mode" action:nil keyEquivalent:@""];
//        NSMenuItem *colorInsertionModeNSItem = [[NSMenuItem alloc] initWithTitle:@"NSColor" action:@selector(selectNSColorInsertionMode:) keyEquivalent:@""];
//        [colorInsertionModeNSItem setTarget:self];
//        NSMenuItem *colorInsertionModeUIItem = [[NSMenuItem alloc] initWithTitle:@"UIColor" action:@selector(selectUIColorInsertionMode:) keyEquivalent:@""];
//        [colorInsertionModeUIItem setTarget:self];
//        
//        NSMenu *colorInsertionModeMenu = [[NSMenu alloc] initWithTitle:@"Color Insertion Mode"];
//        [colorInsertionModeItem setSubmenu:colorInsertionModeMenu];
//        [[colorInsertionModeItem submenu] addItem:colorInsertionModeUIItem];
//        [[colorInsertionModeItem submenu] addItem:colorInsertionModeNSItem];
//        [[editMenuItem submenu] addItem:colorInsertionModeItem];
//        
//        NSMenuItem *insertColorMenuItem = [[NSMenuItem alloc] initWithTitle:@"Insert Animation TimeingFunction..." action:@selector(insertColor:) keyEquivalent:@""];
//        [insertColorMenuItem setTarget:self];
//        [[editMenuItem submenu] addItem:insertColorMenuItem];
    }
    
    BOOL enabled = ![[NSUserDefaults standardUserDefaults] boolForKey:kCATweakerHelperHighlightingDisabled];
    if (enabled) {
        [self activateCAT];
    }
}


- (void)dismissCurveView
{
    [catFrameView removeFromSuperview];
//    if (self.colorWell.isActive) {
//        [self.colorWell deactivate];
//        [[NSColorPanel sharedColorPanel] orderOut:nil];
//    }
//    [self.colorWell removeFromSuperview];
//    [self.colorFrameView removeFromSuperview];
//    self.selectedColorRange = NSMakeRange(NSNotFound, 0);
//    self.selectedColorType = OMColorTypeNone;
}

#pragma mark - Preferences

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(toggleCAT:)) {
        BOOL disabled = [[NSUserDefaults standardUserDefaults] boolForKey:kCATweakerHelperHighlightingDisabled];
        [menuItem setState:disabled ? NSOffState : NSOnState];
        return YES;
    }
    return YES;
}

- (void)toggleCAT:(id)sender
{
    BOOL disabled = [[NSUserDefaults standardUserDefaults] boolForKey:kCATweakerHelperHighlightingDisabled];
    [[NSUserDefaults standardUserDefaults] setBool:!disabled forKey:kCATweakerHelperHighlightingDisabled];
    if (disabled) {
        [self activateCAT];
    } else {
        [self deactivateCAT];
    }
}

//- (void)selectNSColorInsertionMode:(id)sender
//{
//    
//}
//
//- (void)insertColor:(id)sender
//{
//    
//}
//
//- (void)selectUIColorInsertionMode:(id)sender
//{
//    
//}

- (void)activateCAT
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectionDidChange:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
    
    if (!self.textView) {
        NSResponder *firstResponder = [[NSApp keyWindow] firstResponder];
        if ([firstResponder isKindOfClass:NSClassFromString(@"DVTSourceTextView")] && [firstResponder isKindOfClass:[NSTextView class]]) {
            self.textView = (NSTextView *)firstResponder;
        }
    }
    if (self.textView) {
        NSNotification *notification = [NSNotification notificationWithName:NSTextViewDidChangeSelectionNotification object:self.textView];
        [self selectionDidChange:notification];
    }
}

- (void)deactivateCAT
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTextViewDidChangeSelectionNotification object:nil];
    [self dismissCurveView];
    //self.textView = nil;
}

- (void)windowDidResize:(NSNotification*)notification
{
    [self dismissCurveView];
}

- (NSColor*)textViewBackgroundHighContrastColor
{
    NSColor *backgroundColor = [self.textView.backgroundColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
    CGFloat r = 1.0; CGFloat g = 1.0; CGFloat b = 1.0;
    [backgroundColor getRed:&r green:&g blue:&b alpha:NULL];
    CGFloat backgroundLuminance = (r + g + b) / 3.0;
    NSColor *highContrastColor = (backgroundLuminance > 0.5) ? [NSColor colorWithCalibratedWhite:0.2 alpha:1.0] : [NSColor whiteColor];
    return highContrastColor;
}

#pragma mark - Text Selection Handling

- (void)selectionDidChange:(NSNotification *)notification
{
    if ([[notification object] isKindOfClass:NSClassFromString(@"DVTSourceTextView")] && [[notification object] isKindOfClass:[NSTextView class]]) {
        self.textView = (NSTextView *)[notification object];
        BOOL disabled = [[NSUserDefaults standardUserDefaults] boolForKey:kCATweakerHelperHighlightingDisabled];
        if (disabled) return;
        
        [NSColor colorWithCalibratedRed:0.842 green:0.000 blue:0.009 alpha:1.000];
        
        
        CAMediaTimingFunction *fun1 = [CAMediaTimingFunction functionWithControlPoints: 0.016667 : 0.653333 : 0.150000 : 0.960000];
        CAMediaTimingFunction *fun2 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        CAMediaTimingFunction *fun3 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        CAMediaTimingFunction *fun4 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        CAMediaTimingFunction *fun5 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        CAMediaTimingFunction *fun6 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];

        
        
        
        
        fun1;
        fun2;
        fun3;
        fun4;
        fun5;
        fun6;
        
        NSArray *selectedRanges = [self.textView selectedRanges];
        if (selectedRanges.count >= 1) {
            NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
            NSString *text = self.textView.textStorage.string;
            NSRange lineRange = [text lineRangeForRange:selectedRange];
            NSRange selectedRangeInLine = NSMakeRange(selectedRange.location - lineRange.location, selectedRange.length);
            NSString *line = [text substringWithRange:lineRange];
          
            NSRange functionRange = NSMakeRange(NSNotFound, 0);
            CAMediaTimingFunction *matchedFunction = [self timingFunctionInText:line selectedRange:selectedRangeInLine matchedRange:&functionRange];
            
            if (matchedFunction) {
                
                NSString *desc = matchedFunction.description;
                
                NSLog(@"matchedFunction=%@", desc);
                
                if (!catFrameView) {
                    catFrameView = [[CATFrameView alloc] initWithFrame:NSZeroRect];
                }
                
                NSRange selectedFunctionRange = NSMakeRange(functionRange.location + lineRange.location, functionRange.length);
                NSRect selectionRectOnScreen = [self.textView firstRectForCharacterRange:selectedFunctionRange];
                NSRect selectionRectInWindow = [self.textView.window convertRectFromScreen:selectionRectOnScreen];
                NSRect selectionRectInView = [self.textView convertRect:selectionRectInWindow fromView:nil];
                
                catFrameView.strokeColor = [self textViewBackgroundHighContrastColor];
                catFrameView.frame = NSInsetRect(NSIntegralRect(selectionRectInView), -1, -1);
                catFrameView.frame = NSMakeRect(catFrameView.frame.origin.x, catFrameView.frame.origin.y-catFrameView.buttonHeight, catFrameView.frame.size.width, catFrameView.frame.size.height+catFrameView.buttonHeight);
                catFrameView.timingFunction = matchedFunction;
                
                [self.textView addSubview:catFrameView];
                
            } else {
                [self dismissCurveView];
            }
            
        } else {
            [self dismissCurveView];
        }
    }
}


#pragma mark - timingFunction String Parsing

- (double)dividedValue:(double)value
      withDivisorRange:(NSRange)divisorRange
              inString:(NSString *)text
{
    if (divisorRange.location != NSNotFound) {
        double divisor = [[[text substringWithRange:divisorRange] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/ "]] doubleValue];
        if (divisor != 0) {
            value /= divisor;
        }
    }
    return value;
}


- (CAMediaTimingFunction *)timingFunctionInText:(NSString *)text
                                  selectedRange:(NSRange)selectedRange
                                   matchedRange:(NSRangePointer)matchedRange
{
    __block CAMediaTimingFunction *foundFunction = nil;
    __block NSRange foundFunctionRange = NSMakeRange(NSNotFound, 0);
   
    [_timingFunctionWithNameRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSRange functionRange = [result range];
        if (selectedRange.location >= functionRange.location && NSMaxRange(selectedRange) <= NSMaxRange(functionRange)) {
            
            NSString *functionName = [text substringWithRange:[result rangeAtIndex:2]];
            functionName = [functionName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
            if ([functionName isEqualTo:@"kCAMediaTimingFunctionLinear"]) {
                foundFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            }
            else if ([functionName isEqualTo:@"kCAMediaTimingFunctionEaseIn"]) {
                foundFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
            }
            else if ([functionName isEqualTo:@"kCAMediaTimingFunctionEaseOut"]) {
                foundFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            }
            else if ([functionName isEqualTo:@"kCAMediaTimingFunctionEaseInEaseOut"]) {
                foundFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            }
            else if ([functionName isEqualTo:@"kCAMediaTimingFunctionDefault"]) {
                foundFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
            }
            
            foundFunctionRange = functionRange;
            *stop = YES;
        }
    }];
    
    NSLog(@"foundFunction0=%@", foundFunction);
    
    if (!foundFunction) {
        
        NSLog(@"!foundFunction");
        
        [_timingFunctionWithControlPointsRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange functionRange = [result range];
            NSLog(@"functionRange = %@", NSStringFromRange(functionRange));
            NSLog(@"selectedRange = %@", NSStringFromRange(selectedRange));
            
            if (selectedRange.location >= functionRange.location && NSMaxRange(selectedRange) <= NSMaxRange(functionRange)) {
                double p1x = [[text substringWithRange:[result rangeAtIndex:2]] doubleValue];
                p1x = [self dividedValue:p1x withDivisorRange:[result rangeAtIndex:3] inString:text];
                
                double p1y = [[text substringWithRange:[result rangeAtIndex:4]] doubleValue];
                p1y = [self dividedValue:p1y withDivisorRange:[result rangeAtIndex:5] inString:text];
                
                double p2x = [[text substringWithRange:[result rangeAtIndex:6]] doubleValue];
                p2x = [self dividedValue:p2x withDivisorRange:[result rangeAtIndex:7] inString:text];
                
                double p2y = [[text substringWithRange:[result rangeAtIndex:8]] doubleValue];
                p2y = [self dividedValue:p2y withDivisorRange:[result rangeAtIndex:9] inString:text];
                
                foundFunction = [CAMediaTimingFunction functionWithControlPoints:p1x :p1y :p2x :p2y];
                
                foundFunctionRange = functionRange;
                *stop = YES;
            }
        }];
    }
    
    if (foundFunction) {
        if (matchedRange != NULL) {
            *matchedRange = foundFunctionRange;
        }
        return foundFunction;
    }
    
    return nil;
}

#pragma mark -

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
