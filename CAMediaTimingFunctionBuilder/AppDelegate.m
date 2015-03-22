//
//  AppDelegate.m
//  CAMediaTimingFunctionBuilder
//
//  Created by X on 2015-03-21.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import "AppDelegate.h"

#define OBVALL (NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial)


@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@end





@implementation AppDelegate


+ (void)registerUserDefaults{
    
    NSDictionary *defaultValues = @{
                                    @"dot1Origin": NSStringFromPoint(NSMakePoint(75, 280)),
                                    @"dot2Origin": NSStringFromPoint(NSMakePoint(290, 160)),
                                    };
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    [[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
}


+ (void)initialize{
    if ( self == [AppDelegate class] ) {
        [[self class] registerUserDefaults];
    }
}

#pragma mark - AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(pointChangeNotification:)
               name:@"PointChangeNotification"
             object:nil];
    
    [self pointChangeNotification:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag
{
    [_window makeKeyAndOrderFront:self];
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
    return NO;
}

#pragma mark - Observer Callback

- (void)pointChangeNotification:(NSNotification*)n
{
    NSPoint p1 = _curveView.point1;
    NSPoint p2 = _curveView.point2;
    NSLog(@"%@ %@", NSStringFromPoint(p1), NSStringFromPoint(p2));
    
    NSDictionary *keywordAttribute = @{ NSForegroundColorAttributeName : [NSColor colorWithDeviceRed:0.419 green:0.124 blue:0.684 alpha:1.000]};
    NSDictionary *textAttribute = @{ NSForegroundColorAttributeName : [NSColor blackColor]};
    NSDictionary *numberAttribute = @{ NSForegroundColorAttributeName : [NSColor colorWithDeviceRed:0.000 green:0.195 blue:0.990 alpha:1.000]};
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"CAMediaTimingFunction" attributes:keywordAttribute];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" *timingFunction = [" attributes:textAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"CAMediaTimingFunction " attributes:keywordAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"functionWithControlPoints: " attributes:textAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", p1.x] attributes:numberAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" : " attributes:textAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", p1.y] attributes:numberAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" : " attributes:textAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", p2.x] attributes:numberAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" : " attributes:textAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f", p2.y] attributes:numberAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"];" attributes:textAttribute]];

    //[CAMediaTimingFunction functionWithControlPoints:0.1 : 0.8 : 0.2 : 0.8]
    [_textView.textStorage setAttributedString:str];
}


@end
