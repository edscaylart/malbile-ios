//
//  AnimeDetailTableViewController.h
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+animes.h"
#import "StatusTableViewController.h"

@interface AnimeDetailTableViewController : UITableViewController <UIAlertViewDelegate, StatusTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *myStatus;
@property (weak, nonatomic) IBOutlet UILabel *episodes;

@property(nonatomic, strong) NSDictionary *animeDictionary;

- (IBAction)plusEpisode:(id)sender;

- (IBAction)save:(id)sender;
- (IBAction)deleteAnime:(id)sender;
@end
