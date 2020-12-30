//
//  SearchViewController.h
//  MALbile
//
//  Created by Edson Souza on 10/22/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;

- (IBAction)backgroundTap:(id)sender;
@end
