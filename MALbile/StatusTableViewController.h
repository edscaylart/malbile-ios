//
//  StatusTableViewController.h
//  MALbile
//
//  Created by Edson Souza on 10/18/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StatusTableViewControllerDelegate <NSObject>
- (void) addItemViewController:(id)controller didFinishEnteringItem:(NSString *)item;
@end

@interface StatusTableViewController : UITableViewController

@property(nonatomic, strong) NSNumber *selectedId;
@property(nonatomic, strong) NSArray *idStatus;
@property(nonatomic, strong) NSArray *descStatus;

@property (nonatomic, weak) id <StatusTableViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
