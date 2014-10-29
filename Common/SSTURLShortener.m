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
NSString * const SSTBitlyAccessTokenParameter      = @"access_token";
NSString * const SSTBitlyLongUrlParameter          = @"longUrl";
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

+ (void)shortenURL:(NSURL *)url accessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSURL *shortenedURL, NSError *error))completionBlock {
    if (!url || !accessToken.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    NSDictionary *parameters = @{
                                 SSTBitlyAccessTokenParameter : accessToken,
                                 SSTBitlyLongUrlParameter: url.absoluteString,
                                 SSTBitlyFormatParameter: SSTBitlyFormat
                                 };
    
    [self shortenURL:url parameters:parameters withCompletionBlock:completionBlock];
}

+ (void)shortenURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^)(NSURL *shortenedURL, NSError *error))completionBlock {
    if (!url || !username.length || !apiKey.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    NSDictionary *parameters = @{
                                SSTBitlyLoginParameter : username,
                                SSTBitlyApiKeyParameter : apiKey,
                                SSTBitlyLongUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    [self shortenURL:url parameters:parameters withCompletionBlock:completionBlock];
}

+ (void)expandURL:(NSURL *)url accessToken:(NSString *)accessToken withCompletionBlock:(void (^)(NSURL *expandedURL, NSError *error))completionBlock {
    if (!url || !accessToken.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return;
    }
    
    NSDictionary *parameters =@{
                                SSTBitlyAccessTokenParameter : accessToken,
                                SSTBitlyShortUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    [self expandURL:url parameters:parameters withCompletionBlock:completionBlock];
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
    
    NSDictionary *parameters =@{
                                SSTBitlyLoginParameter : username,
                                SSTBitlyApiKeyParameter : apiKey,
                                SSTBitlyShortUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    [self expandURL:url parameters:parameters withCompletionBlock:completionBlock];
}

#pragma mark - Private
#pragma mark -

+ (void)shortenURL:(NSURL *)url parameters:(NSDictionary *)parameters withCompletionBlock:(void (^)(NSURL *shortenedURL, NSError *error))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SSTBitlyBaseURL, SSTBitlyShortenPath];
    NSURL *apiurl = [NSURL URLWithString:urlString];
    
    [self fetchJsonRequestWithURL:apiurl params:parameters withCompletionBlock:^(id response, NSError *error) {
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Failure while shortening URL", @"Error message while shortening URL")};
            NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
        else {
            NSDictionary *dictionary = (NSDictionary *)response;
            
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
    }];
    
}

+ (void)expandURL:(NSURL *)url parameters:(NSDictionary *)parameters withCompletionBlock:(void (^)(NSURL *expandedURL, NSError *error))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SSTBitlyBaseURL, SSTBitlyExpandPath];
    NSURL *apiurl = [NSURL URLWithString:urlString];
    
    [self fetchJsonRequestWithURL:apiurl params:parameters withCompletionBlock:^(id response, NSError *error) {
        if (error) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Failure while expanding URL", @"Error message while shortening URL")};
            NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
            if (completionBlock) {
                completionBlock(nil, error);
            }
        }
        else {
            NSDictionary *dictionary = (NSDictionary *)response;
            
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
    }];
}

+ (void)fetchJsonRequestWithURL:(NSURL *)url params:(NSDictionary *)params withCompletionBlock:(void (^)(id response, NSError *error))completionBlock {
    if (!completionBlock) {
        return;
    }
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    NSError *error;
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:@"GET" URLString:[url absoluteString] parameters:params error:&error];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    request.timeoutInterval = 10.0;
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        completionBlock(response, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock(nil, error);
    }];
    [operation start];
}

@end
