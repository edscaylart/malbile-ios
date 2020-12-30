//
//  AnimeListTableViewCell.h
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimeListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *aTitle;
@property (nonatomic, weak) IBOutlet UILabel *aStatus;
@property (nonatomic, weak) IBOutlet UILabel *aType;
@property (nonatomic, weak) IBOutlet UILabel *aEpisodes;
@property (nonatomic, weak) IBOutlet UIImageView *aThumbnail;

@end
