//
//  SearchViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/22/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTabBarController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize searchBar;
@synthesize searchBarController;

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)search {
   /* NSString *searchString = searchBar.text;
    SearchTabBarController *searchView = [[SearchTabBarController alloc]init];
    searchView.searchTitle = searchString;*/

    [self performSegueWithIdentifier:@"SearchSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *searchString = searchBar.text;    
    searchString = [searchString stringByReplacingOccurrencesOfString:@" "
                                         withString:@"%20"];
    
    SearchTabBarController *searchView = (SearchTabBarController *)segue.destinationViewController;
    searchView.searchTitle = searchString;

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Search Clicked");
    [self search];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Cancel clicked");
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
@end
