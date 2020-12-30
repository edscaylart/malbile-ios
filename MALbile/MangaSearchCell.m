//
//  MangaSearchCell.m
//  MALbile
//
//  Created by Edson Souza on 10/24/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "MangaSearchCell.h"

@implementation MangaSearchCell

@synthesize aTitle;
@synthesize aStatus;
@synthesize aType;
@synthesize aChapters;
@synthesize aThumbnail;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
