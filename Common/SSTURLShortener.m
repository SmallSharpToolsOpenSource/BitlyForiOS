//
//  SSTURLShortener.m
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTURLShortener.h"

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

+ (NSURLSessionTask *)shortenURL:(NSURL *)url accessToken:(NSString *)accessToken withCompletionBlock:(void (^ __nullable)(NSURL *shortenedURL, NSError *error))completionBlock {
    if (!url || !accessToken.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return nil;
    }
    
    NSDictionary *parameters = @{
                                 SSTBitlyAccessTokenParameter : accessToken,
                                 SSTBitlyLongUrlParameter: url.absoluteString,
                                 SSTBitlyFormatParameter: SSTBitlyFormat
                                 };
    
    return [self shortenURL:url parameters:parameters withCompletionBlock:completionBlock];
}

+ (NSURLSessionTask *)shortenURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^ __nullable)(NSURL *shortenedURL, NSError *error))completionBlock {
    if (!url || !username.length || !apiKey.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return nil;
    }
    
    NSDictionary *parameters = @{
                                SSTBitlyLoginParameter : username,
                                SSTBitlyApiKeyParameter : apiKey,
                                SSTBitlyLongUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    return [self shortenURL:url parameters:parameters withCompletionBlock:completionBlock];
}

+ (NSURLSessionTask *)expandURL:(NSURL *)url accessToken:(NSString *)accessToken withCompletionBlock:(void (^ __nullable)(NSURL *expandedURL, NSError *error))completionBlock {
    if (!url || !accessToken.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return nil;
    }
    
    NSDictionary *parameters =@{
                                SSTBitlyAccessTokenParameter : accessToken,
                                SSTBitlyShortUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    return [self expandURL:url parameters:parameters withCompletionBlock:completionBlock];
}

+ (NSURLSessionTask *)expandURL:(NSURL *)url username:(NSString *)username apiKey:(NSString *)apiKey withCompletionBlock:(void (^ __nullable)(NSURL *expandedURL, NSError *error))completionBlock {
    if (!url || !username.length || !apiKey.length) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Required parameters not provided."};
        NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
        if (completionBlock) {
            completionBlock(nil, error);
        }
        return nil;
    }
    
    NSDictionary *parameters =@{
                                SSTBitlyLoginParameter : username,
                                SSTBitlyApiKeyParameter : apiKey,
                                SSTBitlyShortUrlParameter: url.absoluteString,
                                SSTBitlyFormatParameter: SSTBitlyFormat
                                };
    
    return [self expandURL:url parameters:parameters withCompletionBlock:completionBlock];
}

#pragma mark - Private
#pragma mark -

+ (NSURLSessionTask *)shortenURL:(NSURL *)url parameters:(NSDictionary *)parameters withCompletionBlock:(void (^ __nullable)(NSURL *shortenedURL, NSError *error))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SSTBitlyBaseURL, SSTBitlyShortenPath];
    NSURL *apiurl = [NSURL URLWithString:urlString];
    
    return [self fetchJsonRequestWithURL:apiurl params:parameters withCompletionBlock:^(id response, NSError *error) {
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

+ (NSURLSessionTask *)expandURL:(NSURL *)url parameters:(NSDictionary *)parameters withCompletionBlock:(void (^ __nullable)(NSURL *expandedURL, NSError *error))completionBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", SSTBitlyBaseURL, SSTBitlyExpandPath];
    NSURL *apiurl = [NSURL URLWithString:urlString];
    
    return [self fetchJsonRequestWithURL:apiurl params:parameters withCompletionBlock:^(id response, NSError *error) {
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

+ (NSURLSessionTask *)fetchJsonRequestWithURL:(NSURL *)url params:(NSDictionary *)params withCompletionBlock:(void (^ __nullable)(id response, NSError *error))completionBlock {
    if (!completionBlock) {
        return nil;
    }
    
    url = [self appendQueryParameters:params toURL:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            completionBlock(nil, error);
        }
        else {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            // return to main queue from background
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error != nil) {
                    completionBlock(nil, error);
                }
                else if ([json isKindOfClass:[NSDictionary class]]) {
                    completionBlock(json, nil);
                }
                else {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Unexpected Response"};
                    NSError *error = [NSError errorWithDomain:@"Bitly" code:101 userInfo:userInfo];
                    completionBlock(nil, error);
                }
            });
        }
    }];
    [task resume];
    
    return task;
}

+ (NSURL *)appendQueryParameters:(NSDictionary *)params toURL:(NSURL *)url {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = @[].mutableCopy;
    
    for (NSString *name in params) {
        NSObject *parameterValue = params[name];
        
        NSURLQueryItem *item = nil;
        
        if ([parameterValue isKindOfClass:[NSString class]]) {
            item = [[NSURLQueryItem alloc] initWithName:name value:params[name]];
        }
        else if ([parameterValue respondsToSelector:@selector(stringValue)]) {
            item = [[NSURLQueryItem alloc] initWithName:name value:[params[name] stringValue]];
        }
        
        if (item) {
            [queryItems addObject:item];
        }
    }
    
    components.queryItems = queryItems;
    
    return components.URL;
}

@end
