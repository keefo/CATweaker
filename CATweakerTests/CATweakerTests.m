//
//  CATweakerTests.m
//  CATweakerTests
//
//  Created by X on 2015-03-21.
//  Copyright (c) 2015 Beyondcow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "CATweakerHelper.h"

@interface CATweakerTests : XCTestCase

@end

@implementation CATweakerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTimingFunctionWithNameRegex {
    
    // testing TimingFunctionWithNameRegex.

    CATweakerHelper *helper = [[CATweakerHelper alloc] init];
    
    NSMutableArray *textArray = [NSMutableArray array];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionLinear]"];
    [textArray addObject:@"[ CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionLinear  ]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionLinear  ]"];
    [textArray addObject:@"[CAMediaTimingFunction          functionWithName:  kCAMediaTimingFunctionLinear  ]"];
    [textArray addObject:@"[CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionLinear    ]   "];
    [textArray addObject:@" [   CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionLinear    ]   "];
    [textArray addObject:@"  [ CAMediaTimingFunction functionWithName:   kCAMediaTimingFunctionLinear    ]   "];
    
    __block int pass = 0;
    
    for(NSString *text in textArray){
        [helper.timingFunctionWithNameRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            XCTAssertTrue([result numberOfRanges] == 3, @"timingFunctionWithNameRegex not matching %@", text);
            XCTAssertEqualObjects(@"kCAMediaTimingFunctionLinear", [text substringWithRange:[result rangeAtIndex:2]], @"kCAMediaTimingFunctionLinear is not matching %@", text);
            
            pass++;
        }];
    }
    
    if (pass!=textArray.count) {
        XCTFail(@"not pass");
    }
    
    
    textArray = [NSMutableArray array];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseIn]"];
    [textArray addObject:@"[ CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseIn  ]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseIn  ]"];
    [textArray addObject:@"[CAMediaTimingFunction          functionWithName:  kCAMediaTimingFunctionEaseIn  ]"];
    [textArray addObject:@"[CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionEaseIn    ]   "];
    [textArray addObject:@" [   CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionEaseIn    ]   "];
    [textArray addObject:@"  [ CAMediaTimingFunction functionWithName:   kCAMediaTimingFunctionEaseIn    ]   "];
    
    pass = 0;
    for(NSString *text in textArray){
        [helper.timingFunctionWithNameRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            XCTAssertTrue([result numberOfRanges] == 3, @"timingFunctionWithNameRegex not matching %@", text);
            XCTAssertEqualObjects(@"kCAMediaTimingFunctionEaseIn", [text substringWithRange:[result rangeAtIndex:2]], @"kCAMediaTimingFunctionEaseIn is not matching %@", text);
            pass++;
        }];
    }
    
    if (pass!=textArray.count) {
        XCTFail(@"not pass");
    }

    
    textArray = [NSMutableArray array];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseOut]"];
    [textArray addObject:@"[ CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseOut  ]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseOut  ]"];
    [textArray addObject:@"[CAMediaTimingFunction          functionWithName:  kCAMediaTimingFunctionEaseOut  ]"];
    [textArray addObject:@"[CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionEaseOut    ]   "];
    [textArray addObject:@" [   CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionEaseOut    ]   "];
    [textArray addObject:@"  [ CAMediaTimingFunction functionWithName:   kCAMediaTimingFunctionEaseOut    ]   "];
    
    pass = 0;
    for(NSString *text in textArray){
        [helper.timingFunctionWithNameRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            XCTAssertTrue([result numberOfRanges] == 3, @"timingFunctionWithNameRegex not matching %@", text);
            XCTAssertEqualObjects(@"kCAMediaTimingFunctionEaseOut", [text substringWithRange:[result rangeAtIndex:2]], @"kCAMediaTimingFunctionEaseOut is not matching %@", text);
            pass++;
        }];
    }
    
    if (pass!=textArray.count) {
        XCTFail(@"not pass");
    }

    
    textArray = [NSMutableArray array];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseInEaseOut]"];
    [textArray addObject:@"[ CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseInEaseOut  ]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionEaseInEaseOut  ]"];
    [textArray addObject:@"[CAMediaTimingFunction          functionWithName:  kCAMediaTimingFunctionEaseInEaseOut  ]"];
    [textArray addObject:@"[CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionEaseInEaseOut    ]   "];
    [textArray addObject:@" [   CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionEaseInEaseOut    ]   "];
    [textArray addObject:@"  [ CAMediaTimingFunction functionWithName:   kCAMediaTimingFunctionEaseInEaseOut    ]   "];
    
    pass = 0;
    for(NSString *text in textArray){
        [helper.timingFunctionWithNameRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            XCTAssertTrue([result numberOfRanges] == 3, @"timingFunctionWithNameRegex not matching %@", text);
            XCTAssertEqualObjects(@"kCAMediaTimingFunctionEaseInEaseOut", [text substringWithRange:[result rangeAtIndex:2]], @"kCAMediaTimingFunctionEaseInEaseOut is not matching %@", text);
            pass++;
        }];
    }
    
    if (pass!=textArray.count) {
        XCTFail(@"not pass");
    }
    
    
    textArray = [NSMutableArray array];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionDefault]"];
    [textArray addObject:@"[ CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionDefault  ]"];
    [textArray addObject:@"[CAMediaTimingFunction functionWithName:  kCAMediaTimingFunctionDefault  ]"];
    [textArray addObject:@"[CAMediaTimingFunction          functionWithName:  kCAMediaTimingFunctionDefault  ]"];
    [textArray addObject:@"[CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionDefault    ]   "];
    [textArray addObject:@" [   CAMediaTimingFunction           functionWithName:   kCAMediaTimingFunctionDefault    ]   "];
    [textArray addObject:@"  [ CAMediaTimingFunction functionWithName:   kCAMediaTimingFunctionDefault    ]   "];
    
    pass = 0;
    for(NSString *text in textArray){
        [helper.timingFunctionWithNameRegex enumerateMatchesInString:text options:0 range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            XCTAssertTrue([result numberOfRanges] == 3, @"timingFunctionWithNameRegex not matching %@", text);
            XCTAssertEqualObjects(@"kCAMediaTimingFunctionDefault", [text substringWithRange:[result rangeAtIndex:2]], @"kCAMediaTimingFunctionDefault is not matching %@", text);
            pass++;
        }];
    }
    
    if (pass!=textArray.count) {
        XCTFail(@"not pass");
    }

}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
