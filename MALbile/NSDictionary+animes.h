//
//  NSDictionary+animes.h
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (animes)

- (NSNumber *)idAnime;
- (NSString *)title;
- (NSNumber *)idStatus;
- (NSNumber *)idType;
- (NSNumber *)episodes;
- (NSNumber *)idMyStatus;
- (NSNumber *)watchedEpisodes;
- (NSString *)urlThumbnail;

- (NSString *)descStatus;
- (NSString *)descType;
- (NSString *)descMyStatus;
- (NSString *)descEpisodes;

@end
