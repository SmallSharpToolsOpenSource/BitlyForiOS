//
//  SSTURLShortener.h
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

@import Foundation;

@interface SSTURLShortener : NSObject

+ (nullable NSURLSessionTask *)shortenURL:(nullable NSURL *)url accessToken:(nullable NSString *)accessToken withCompletionBlock:(void (^ __nullable)(NSURL * _Nullable shortenedURL, NSError * _Nullable error))completionBlock;

+ (nullable NSURLSessionTask *)shortenURL:(nullable NSURL *)url username:(nullable NSString *)username apiKey:(nullable NSString *)apiKey withCompletionBlock:(void (^ __nullable)(NSURL * _Nullable shortenedURL, NSError * _Nullable error))completionBlock;

+ (nullable NSURLSessionTask *)expandURL:(nullable NSURL *)url accessToken:(nullable NSString *)accessToken withCompletionBlock:(void (^ __nullable)(NSURL * _Nullable expandedURL, NSError * _Nullable error))completionBlock;

+ (nullable NSURLSessionTask *)expandURL:(nullable NSURL *)url username:(nullable NSString *)username apiKey:(nullable NSString *)apiKey withCompletionBlock:(void (^ __nullable)(NSURL * _Nullable expandedURL, NSError * _Nullable error))completionBlock;

@end
