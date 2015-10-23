//
//  BitlyForiOSTests.m
//  BitlyForiOSTests
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "BitlyForiOSTests.h"

#import "SSTViewController.h"
#import "SSTURLShortener.h"

@implementation BitlyForiOSTests {
    NSString *_username;
    NSString *_apiKey;
    NSString *_accessToken;
}

- (void)setUp {
    [super setUp];
    
    // Set-up code here.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _username = [defaults objectForKey:SSTUsername];
    _apiKey = [defaults objectForKey:SSTApiKey];
    _accessToken = [defaults objectForKey:SSTAccessToken];
}

- (void)tearDown {
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testAPIKeyShrinkAndExpand {
    XCTAssertNotNil(_username, @"Username must be defined by test app");
    XCTAssertNotNil(_apiKey, @"API Key must be defined by test app");
    
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Bitly"];
    [SSTURLShortener shortenURL:url username:_username apiKey:_apiKey withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(shortenedURL);
        NSLog(@"shortenedURL: %@", shortenedURL);
        [SSTURLShortener expandURL:shortenedURL username:_username apiKey:_apiKey withCompletionBlock:^(NSURL *expandedURL, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(expandedURL);
            NSLog(@"expandedURL: %@", expandedURL);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        // done
    }];
}

- (void)testAccessTokenShrinkAndExpand {
    XCTAssertNotNil(_accessToken, @"Access token must be defined by test app");
    
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com/"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Bitly"];
    [SSTURLShortener shortenURL:url accessToken:_accessToken withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
        XCTAssertNil(error);
        XCTAssertNotNil(shortenedURL);
        NSLog(@"shortenedURL: %@", shortenedURL);
        [SSTURLShortener expandURL:shortenedURL accessToken:_accessToken withCompletionBlock:^(NSURL *expandedURL, NSError *error) {
            XCTAssertNil(error);
            XCTAssertNotNil(expandedURL);
            NSLog(@"expandedURL: %@", expandedURL);
            
            [expectation fulfill];
        }];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        // done
    }];
}

@end
