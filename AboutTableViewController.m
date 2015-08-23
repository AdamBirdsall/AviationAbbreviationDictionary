//
//  AboutTableViewController.m
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 6/30/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//

#import "AboutTableViewController.h"
#import <iAd/iAd.h>

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

- (IBAction)RateApp:(id)sender {
    NSString *str = @"itms-apps://itunes.apple.com/app/id880441616";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)GoToWebsite:(id)sender {
    NSString *str = @"http://adambirdsallappsupport.blogspot.com/";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)SendEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Aviation Abbreviation Dictionary";
    
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"adam.birdsall4@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
