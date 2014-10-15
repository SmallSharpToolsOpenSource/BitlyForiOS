//
//  SSTURLShortener.m
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTURLShortener.h"

#import "AFNetworking.h"

NSString * const SSTBitlyBaseURL                   = @"https://api-ssl.bitly.com/";
NSString * const SSTBitlyShortenPath               = @"/v3/shorten";
NSString * const SSTBitlyExpandPath                = @"/v3/expand";
NSString * const SSTBitlyLoginParameter            = @"login";
NSString * const SSTBitlyApiKeyParameter           = @"apiKey";
NSString * const SSTBitlyURIParameter              = @"uri";
NSString * const SSTBitlyShortUrlParameter         = @"shortUrl";
NSString * const SSTBitlyFormatParameter           = @"format";
NSString * const SSTBitlyFormat                    = @"json";
NSString * const SSTBitlyStatusCodeKey             = @"status_code";
NSString * const SSTBitlyStatusTextKey             = @"status_txt";
NSString * const SSTBitlyDataKey                   = @"data";
NSString * const SSTBitlyExpandKey                 = @"expand";
NSString * const SSTBitlyURLKey                    = @"url";
NSString * const SSTBitlyShortURLKey               = @"short_url";
NSString * const SSTBitlyLongURLKey                = @"long_url";

@implementation SSTURLShortener

+ (void)shortenURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^)(NSURL *shortenedURL, NSError *error))completionBlock {
    if (!url || !username.length || !apiKey.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SSTBitlyBaseURL]];
    NSDictionary *parameters =@{
                                SSTBitlyLoginParameter : username,
                                SSTBitlyApiKeyParameter : apiKey,
                                SSTBitlyURIParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    [sessionManager GET:SSTBitlyShortenPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            
            if ([@"OK" isEqualToString:dictionary[SSTBitlyStatusTextKey]]) {
                NSString *longUrlString = dictionary[SSTBitlyDataKey][SSTBitlyLongURLKey];
#pragma unused (longUrlString)
                NSCAssert([url.absoluteString isEqualToString:longUrlString], @"Returned Long URL must match given Long URL");
                NSString *shortenedUrlString = dictionary[SSTBitlyDataKey][SSTBitlyURLKey];
                NSURL *shortenedURL = [NSURL URLWithString:shortenedUrlString];
                if (completionBlock) {
                    completionBlock(shortenedURL, nil);
                }
            }
            else {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : dictionary[SSTBitlyStatusTextKey]};
                NSInteger statusCode = [dictionary[SSTBitlyStatusCodeKey] integerValue];
                NSError *error = [NSError errorWithDomain:@"Bitly" code:statusCode userInfo:userInfo];
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }
        }
        else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Failure while shortening URL", @"Error message while shortening URL")};
            NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

+ (void)expandURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^)(NSURL *expandedURL, NSError *error))completionBlock {
    if (!url || !username.length || !apiKey.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:SSTBitlyBaseURL]];
    NSDictionary *parameters =@{
                                SSTBitlyLoginParameter : username,
                                SSTBitlyApiKeyParameter : apiKey,
                                SSTBitlyShortUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    [sessionManager GET:SSTBitlyExpandPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = (NSDictionary *)responseObject;
            
            if ([@"OK" isEqualToString:dictionary[SSTBitlyStatusTextKey]]) {
                NSString *shortUrlString = dictionary[SSTBitlyDataKey][SSTBitlyExpandKey][0][SSTBitlyShortURLKey];
#pragma unused (shortUrlString)
                NSCAssert([url.absoluteString isEqualToString:shortUrlString], @"Returned Short URL must match given Short URL");
                NSString *expandedUrlString = dictionary[SSTBitlyDataKey][SSTBitlyExpandKey][0][SSTBitlyLongURLKey];
                NSURL *expandedURL = [NSURL URLWithString:expandedUrlString];
                if (completionBlock) {
                    completionBlock(expandedURL, nil);
                }
            }
            else {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey : dictionary[SSTBitlyStatusTextKey]};
                NSInteger statusCode = [dictionary[SSTBitlyStatusCodeKey] integerValue];
                NSError *error = [NSError errorWithDomain:@"Bitly" code:statusCode userInfo:userInfo];
                if (completionBlock) {
                    completionBlock(nil, error);
                }
            }
        }
        else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Failure while expanding URL", @"Error message while expanding URL")};
            NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

@end
