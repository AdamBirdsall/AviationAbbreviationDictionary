//
//  AboutTableViewController.h
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 6/30/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//
#define k_Save @"Saveitem"

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *purchaseLabel;

- (IBAction)RateApp:(id)sender;
- (IBAction)SendEmail:(id)sender;
- (IBAction)GoToWebsite:(id)sender;

@end
