//
//  SSTViewController.m
//  BitlyForiOS
//
//  Created by Brennan Stehling on 7/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTViewController.h"

#import "SSTURLShortener.h"

@interface SSTViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *apiKeyTextField;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *shortenButton;
@property (weak, nonatomic) IBOutlet UILabel *shortenedURLLabel;

@end

@implementation SSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.shortenedURLLabel.text = nil;
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)shortenURLButtonTapped:(id)sender {
    [self.view endEditing:TRUE];
    
    [SSTURLShortener shortenURL:[NSURL URLWithString:self.urlTextField.text]
                       username:self.usernameTextField.text
                         apiKey:self.apiKeyTextField.text
            withCompletionBlock:^(NSURL *shortenedURL, NSError *error) {
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
                }
    }];
}

@end
