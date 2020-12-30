//
//  AnimeListTableViewController.h
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusTableViewController.h"

@interface AnimeListTableViewController : UITableViewController <NSXMLParserDelegate, StatusTableViewControllerDelegate>

@property(nonatomic, strong) NSNumber *myStatusId;

- (IBAction)refresh:(id)sender;
@end
