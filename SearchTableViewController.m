//
//  SearchTableViewController.m
//  Aviation Abbreviation Dictionary
//
//  Created by Adam Birdsall on 6/27/14.
//  Copyright (c) 2014 Adam Birdsall. All rights reserved.
//
#define k_Save @"Saveitem"

#import "SearchTableViewController.h"
#import "DisplayViewController.h"
#import "AboutTableViewController.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController
{
    NSArray *searchResults;
}

//Setting up query for parse data
//**********************************************************************************************
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // The className to query on
        self.parseClassName = @"Data";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"Abbreviation";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        self.objectsPerPage = 2000;
    }
    return self;
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    if ([self.objects count] == 0) {
        [query setCachePolicy: kPFCachePolicyCacheThenNetwork];
    }
    
    [query orderByAscending:@"Abbreviation"];
    
    return query;
}
//**********************************************************************************************




//View Did Load
//**********************************************************************************************
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

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
        _upgradeButton.title = @"";
        _upgradeButton.enabled = NO;
        self.canDisplayBannerAds = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//**********************************************************************************************




//Table View Methods
//**********************************************************************************************
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [self.objects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        object = [searchResults objectAtIndex:indexPath.row];
    }
    else {
        object = [self.objects objectAtIndex:indexPath.row];
    }

    cell.textLabel.text = [object objectForKey:@"Abbreviation"];
    cell.detailTextLabel.text = [object objectForKey:@"Definition"];
    
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
            indexPath = [self.tableView indexPathForSelectedRow];
            object = [self.objects objectAtIndex:indexPath.row];
        }
    
        Info *info = [[Info alloc] init];
        info.abb = [object objectForKey:@"Abbreviation"];
        info.def = [object objectForKey:@"Definition"];
        
        DisplayViewController *destViewController = segue.destinationViewController;
        destViewController.info = info;
        
        NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
        bool saved = [saveapp boolForKey:k_Save];
        
        if (!saved) {
            //If in-app purchase is not saved, display interstitial ad
            destViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
        }
        else
        {
            //If it is saved then no ad appears
        }
    }
    else if ([segue.identifier isEqualToString:@"ShowAbout"]) {
        AboutTableViewController *destViewController = segue.destinationViewController;
        
        NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
        bool saved = [saveapp boolForKey:k_Save];
        
        if (!saved) {
            //If in-app purchase is not saved, display interstitial ad
            destViewController.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
        }
        else
        {
            //If it is saved then no ad appears
        }
    }
}
//**********************************************************************************************




//Search Bar Methods
//**********************************************************************************************
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Abbreviation beginswith[c] %@", searchText];
    searchResults = [self.objects filteredArrayUsingPredicate:resultPredicate];
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




//Methods for in-app purchase to hide all advertisements
//**********************************************************************************************
- (IBAction)Upgrade:(id)sender {
    
    self.productID = @"com.AviationAbbreviation.RemoveAds";
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    [self getProductInfo:self];
    
    self.canDisplayBannerAds = NO;
}

-(void)Purchased
{
    _upgradeButton.title = @"";
    _upgradeButton.enabled = NO;
    
    NSUserDefaults *saveapp = [NSUserDefaults standardUserDefaults];
    [saveapp setBool:TRUE forKey:k_Save];
    
    [saveapp synchronize];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [self unlockFeature];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Restored" message:@"All ads are hidden." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)unlockFeature
{
    [self Purchased];
}

-(void)getProductInfo:(SearchTableViewController *)viewController
{
    
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:self.productID]];
        
        request.delegate = self;
        
        [request start];
    }
    else {
    }
}
//**********************************************************************************************




//Displaying the in-app purchase on the screen
//**********************************************************************************************
#pragma mark -
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    
    if (products.count != 0) {
        _product = products[0];
        
        //Initial alertview displaying product info and asking to buy, restore, or cancel
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_product.localizedTitle message:_product.localizedDescription delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Purchase", @"Restore Previous Purchase", nil];
        [alert show];
    }
    else {
        //Error message if product cannot be found
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Product not found" message:@"Are you connected to the internet?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products)
    {
        NSLog(@"Product Not found: %@", product);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //Cancel
    if (buttonIndex == 0) {
        NSLog(@"button at 0 clicked");
    }
    //Purchase
    else if (buttonIndex == 1) {
        SKPayment *payment = [SKPayment paymentWithProduct:_product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    //Restore
    else if (buttonIndex == 2) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver

//Confirms whether the payment goes through or not
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
            {
                [self unlockFeature];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
                
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"Transaction Failed");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Try again or restore purchase if you have already bought it. You will not be charged twice." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
        
            default:
                break;
        }
    }
}
//**********************************************************************************************

@end

