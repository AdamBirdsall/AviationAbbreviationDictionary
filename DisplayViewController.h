//
//  DisplayViewController.h
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 6/24/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//
#define k_Save @"Saveitem"

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Info.h"

@interface DisplayViewController : UIViewController <ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *abbrev;
@property (weak, nonatomic) IBOutlet UILabel *define;

@property (nonatomic, strong) Info *info;

@end
