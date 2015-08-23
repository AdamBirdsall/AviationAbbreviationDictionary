//
//  ViewController.h
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 7/1/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <Parse/Parse.h>
#import <StoreKit/StoreKit.h>
#import "AboutTableViewController.h"

@class PurchaseViewController;

@interface ViewController : UIViewController <ADBannerViewDelegate, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *dataView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *upgradeButton;
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;

-(void)Purchased;
- (IBAction)Upgrade:(id)sender;

@end
