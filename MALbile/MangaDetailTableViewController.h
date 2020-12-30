//
//  MangaDetailTableViewController.h
//  MALbile
//
//  Created by Edson Souza on 10/19/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDictionary+mangas.h"
#import "StatusTableViewController.h"

@interface MangaDetailTableViewController : UITableViewController <UIAlertViewDelegate, StatusTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *myStatus;
@property (weak, nonatomic) IBOutlet UILabel *chapters;
@property (weak, nonatomic) IBOutlet UILabel *volumes;

@property(nonatomic, strong) NSDictionary *mangaDictionary;

- (IBAction)plusChapter:(id)sender;
- (IBAction)plusVolume:(id)sender;

- (IBAction)save:(id)sender;
- (IBAction)deleteManga:(id)sender;
@end
