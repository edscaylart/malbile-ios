//
//  NSDictionary+mangas.h
//  MALbile
//
//  Created by Edson Souza on 10/19/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDictionary (mangas)

- (NSNumber *)idManga;
- (NSString *)titleManga;
- (NSNumber *)idStatusManga;
- (NSNumber *)idTypeManga;
- (NSNumber *)chapters;
- (NSNumber *)volumes;
- (NSNumber *)idMyStatusManga;
- (NSNumber *)readChapters;
- (NSNumber *)readVolumes;
- (NSString *)urlThumbnail;

- (NSString *)descStatusManga;
- (NSString *)descTypeManga;
- (NSString *)descMyStatusManga;
- (NSString *)descChapters;
- (NSString *)descVolumes;

@end
