//
//  MangaListTableViewCell.h
//  MALbile
//
//  Created by Edson Souza on 10/19/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MangaListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *aTitle;
@property (nonatomic, weak) IBOutlet UILabel *aStatus;
@property (nonatomic, weak) IBOutlet UILabel *aType;
@property (nonatomic, weak) IBOutlet UILabel *aChapters;
@property (nonatomic, weak) IBOutlet UIImageView *aThumbnail;

@end
