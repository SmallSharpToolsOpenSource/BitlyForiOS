//
//  SSTViewController.m
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTViewController.h"

#import "SSTURLShortener.h"

NSString * const SSTUsername = @"username";
NSString * const SSTApiKey = @"apiKey";
NSString * const SSTAccessToken = @"accessToken";
NSString * const SSTURL = @"url";

@interface SSTViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *accessTokenTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *shortenButton;
@property (weak, nonatomic) IBOutlet UILabel *shortenedURLLabel;

@end

@implementation SSTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.shortenedURLLabel.text = nil;
    [self loadSettings];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)shortenURLButtonTapped:(id)sender {
    [self.view endEditing:TRUE];
    [self saveSettings];
    
    if (self.accessTokenTextField.text.length) {
        [SSTURLShortener shortenURL:[NSURL URLWithString:self.urlTextField.text]
                        accessToken:self.accessTokenTextField.text
                withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
            [self handleShortenedURL:shortenedURL error:error];
        }];
    }
    else {
        [SSTURLShortener shortenURL:[NSURL URLWithString:self.urlTextField.text]
                           username:self.usernameTextField.text
                             apiKey:self.apiKeyTextField.text
                withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
            [self handleShortenedURL:shortenedURL error:error];
        }];
    }
}

#pragma mark - Private
#pragma mark -

- (void)loadSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults objectForKey:SSTUsername];
    NSString *apiKey = [defaults objectForKey:SSTApiKey];
    NSString *accessToken = [defaults objectForKey:SSTAccessToken];
    NSString *url = [defaults objectForKey:SSTURL];
    
    self.usernameTextField.text = username;
    self.apiKeyTextField.text = apiKey;
    self.accessTokenTextField.text = accessToken;
    self.urlTextField.text = url;
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.usernameTextField.text.length) {
        [defaults setObject:self.usernameTextField.text forKey:SSTUsername];
    }
    if (self.apiKeyTextField.text.length) {
        [defaults setObject:self.apiKeyTextField.text forKey:SSTApiKey];
    }
    if (self.accessTokenTextField.text.length) {
        [defaults setObject:self.accessTokenTextField.text forKey:SSTAccessToken];
    }
    if (self.apiKeyTextField.text.length) {
        [defaults setObject:self.urlTextField.text forKey:SSTURL];
    }
    
    [defaults synchronize];
}

- (void)expandShortenedURL:(NSURL *)shortenedURL {
    if (self.accessTokenTextField.text.length) {
        [SSTURLShortener expandURL:shortenedURL
                       accessToken:self.accessTokenTextField.text
               withCompletionBlock:^(NSURL *expandedURL, NSError *error) {
            [self handleExpandedURL:expandedURL error:error];
        }];
    }
    else {
        [SSTURLShortener expandURL:shortenedURL
                          username:self.usernameTextField.text
                            apiKey:self.apiKeyTextField.text
               withCompletionBlock:^(NSURL *expandedURL, NSError *error) {
            [self handleExpandedURL:expandedURL error:error];
        }];
    }
}

- (void)handleExpandedURL:(NSURL *)expandedURL error:(NSError *)error {
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.userInfo[NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        NSLog(@"Expanded URL: %@", expandedURL.absoluteString);
    }
}

- (void)handleShortenedURL:(NSURL *)shortenedURL error:(NSError *)error {
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.userInfo[NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        self.shortenedURLLabel.text = shortenedURL.absoluteString;
        [self expandShortenedURL:shortenedURL];
    }
}

@end
