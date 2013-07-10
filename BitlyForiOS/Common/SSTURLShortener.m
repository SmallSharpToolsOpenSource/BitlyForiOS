//
//  SSTURLShortener.m
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTURLShortener.h"

#import "AFNetworking.h"

NSString * const SSTBitlyBaseURL                   = @"http://api.bit.ly/";
NSString * const SSTBitlyShortenPath               = @"/v3/shorten";
NSString * const SSTBitlyLoginParameter            = @"login";
NSString * const SSTBitlyApiKeyParameter           = @"apiKey";
NSString * const SSTBitlyURIParameter              = @"uri";
NSString * const SSTBitlyFormatParameter           = @"format";
NSString * const SSTBitlyFormat                    = @"json";
NSString * const SSTBitlyStatusCodeKey             = @"status_code";
NSString * const SSTBitlyStatusTextKey             = @"status_txt";
NSString * const SSTBitlyDataKey                   = @"data";
NSString * const SSTBitlyURLKey                    = @"url";

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
    
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:SSTBitlyBaseURL]];
    NSMutableURLRequest *request = [client requestWithMethod:@"GET" path:SSTBitlyShortenPath parameters:@{
                                       SSTBitlyLoginParameter : username,
                                      SSTBitlyApiKeyParameter : apiKey,
                                          SSTBitlyURIParameter: url.absoluteString,
                                       SSTBitlyFormatParameter: SSTBitlyFormat
                                    }];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSData *data = (NSData *)responseObject;
            
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error && completionBlock) {
                completionBlock(nil, error);
            }
            else {
                NSInteger statusCode = [[json objectForKey:SSTBitlyStatusCodeKey] intValue];
                if (statusCode != 200) {
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : [json objectForKey:SSTBitlyStatusTextKey]};
                    NSError *error = [NSError errorWithDomain:@"Bitly" code:statusCode userInfo:userInfo];
                    if (completionBlock) {
                        completionBlock(nil, error);
                    }
                }
                else {
                    NSString *urlString = json[SSTBitlyDataKey][SSTBitlyURLKey];
                    NSURL *shortenedURL = [NSURL URLWithString:urlString];
                    if (completionBlock) {
                        completionBlock(shortenedURL, nil);
                    }
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
    [operation start];
}

@end
