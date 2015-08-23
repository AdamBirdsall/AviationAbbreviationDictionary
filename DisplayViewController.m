//
//  DisplayViewController.m
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 6/24/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//

#import "DisplayViewController.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController

@synthesize abbrev;
@synthesize define;
@synthesize info;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.abbrev.text = info.abb;
    self.define.text = info.def;
    
    NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
    
    bool saved = [saveapp boolForKey:k_Save];
    
    //If in-app purchase is not saved, display ads
    if (!saved) {
        //not saved code here
        self.canDisplayBannerAds = YES;
    }
    //If in-app purchase is saved, do not display ads and disable button
    else
    {
        //saved code here
        self.canDisplayBannerAds = NO;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self setAbbrev:nil];
    [self setDefine:nil];
}

@end
