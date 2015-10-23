//
//  SSTURLShortener.h
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

@import Foundation;

@interface SSTURLShortener : NSObject

+ (NSURLSessionTask *)shortenURL:(NSURL *)url accessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSURL *shortenedURL, NSError *error))completionBlock;

+ (NSURLSessionTask *)shortenURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^)(NSURL *shortenedURL, NSError *error))completionBlock;

+ (NSURLSessionTask *)expandURL:(NSURL *)url accessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSURL *expandedURL, NSError *error))completionBlock;

+ (NSURLSessionTask *)expandURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^)(NSURL *expandedURL, NSError *error))completionBlock;

@end
