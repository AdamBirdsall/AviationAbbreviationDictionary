//
//  SearchTableViewController.h
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 6/27/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <iAd/iAd.h>
#import <StoreKit/StoreKit.h>
#import "Info.h"

@interface SearchTableViewController : PFQueryTableViewController <ADBannerViewDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *about;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *upgradeButton;

-(void)Purchased;
- (IBAction)Upgrade:(id)sender;

@end
