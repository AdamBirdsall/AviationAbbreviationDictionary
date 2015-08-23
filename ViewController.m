//
//  ViewController.m
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 7/1/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//
#define k_Save @"Saveitem"

#import "ViewController.h"
#import "DisplayViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSArray *searchResults, *data;
}

@synthesize dataView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//View did load and iAd Methods
//**********************************************************************************************
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
    
    bool saved = [saveapp boolForKey:k_Save];
    
    [self performSelector:@selector(retrieveFromParse)];
    
    if (!saved) {
        //not saved code here
        //self.canDisplayBannerAds = YES;
    }
    else
    {
        //saved code here
        _upgradeButton.title = @"Restore";
        //self.canDisplayBannerAds = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
    
    bool saved = [saveapp boolForKey:k_Save];
    
    if (!saved) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [banner setAlpha:1];
        [UIView commitAnimations];
    }
    else
    {
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}
//**********************************************************************************************



//Retrieving the data from Parse
//**********************************************************************************************
- (void) retrieveFromParse
{
    PFQuery *retrieveData = [PFQuery queryWithClassName:@"Data"];
    
    retrieveData.limit = 1500;
    
    [retrieveData orderByAscending:@"Abbreviation"];
    
    [retrieveData findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            data = [[NSArray alloc] initWithArray:objects];
        }
        [dataView reloadData];
    }];
}
//**********************************************************************************************



//Setting up the Table View
//**********************************************************************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [dataView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PFObject *tempObject;
    
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        tempObject = [searchResults objectAtIndex:indexPath.row];
    }
    else {
        tempObject = [data objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [tempObject objectForKey:@"Abbreviation"];
    cell.detailTextLabel.text = [tempObject objectForKey:@"Definition"];
    
    return cell;
}
//color of the table view cell
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.backgroundColor = [UIColor colorWithRed:(9/255.0) green:(0/255.0) blue:(188/255.0) alpha:1.0];
    }
    else {
        cell.backgroundColor = [UIColor colorWithRed:(9/255.0) green:(0/255.0) blue:(188/255.0) alpha:1.0];
    }
}
//**********************************************************************************************




//Search Bar Methods
//**********************************************************************************************
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Abbreviation beginswith[cd] %@", searchText];
    searchResults = [data filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}
//**********************************************************************************************




//Prepare For Segue Method
//**********************************************************************************************
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowDefinition"]) {
        
        NSIndexPath *indexPath = nil;
        PFObject *object;
        
        if (self.searchDisplayController.isActive) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            object = [searchResults objectAtIndex:indexPath.row];
        }
        else {
            indexPath = [dataView indexPathForSelectedRow];
            object = [data objectAtIndex:indexPath.row];
            
        }
        
        Info *info = [[Info alloc] init];
        info.abb = [object objectForKey:@"Abbreviation"];
        info.def = [object objectForKey:@"Definition"];
        
        DisplayViewController *destViewController = segue.destinationViewController;
        destViewController.info = info;
        
        NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
        
        bool saved = [saveapp boolForKey:k_Save];
        
        if (!saved) {
            //not saved code here
            destViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
        }
        else
        {
            //saved code here
        }
    }
}
//**********************************************************************************************

- (IBAction)Upgrade:(id)sender {
    /*_purchaseController = [[PurchaseViewController alloc] initWithNibName:nil bundle:nil];
    
    _purchaseController.productID = @"com.rerere";
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_purchaseController];
    
    [self.navigationController pushViewController:_purchaseController animated:YES];
    
    [_purchaseController getProductInfo:self];*/
}

-(void)Purchased
{
    _upgradeButton.enabled = NO;
    
    _upgradeButton.title = @"";
    
    [_adBanner setAlpha:0];
    
    NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
    [saveapp setBool:TRUE forKey:k_Save];
    
    [saveapp synchronize];
}
@end
