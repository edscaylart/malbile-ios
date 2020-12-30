//
//  NSDictionary+search.h
//  MALbile
//
//  Created by Edson Souza on 10/22/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (search)

- (NSNumber *)idSearch;
- (NSString *)titleSearch;
- (NSString *)statusSearch;
- (NSString *)typeSearch;
- (NSString *)episodesSearch;
- (NSString *)chaptersSearch;
- (NSString *)volumesSearch;
- (NSString *)urlThumbnailSearch;

@end
