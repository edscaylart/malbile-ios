//
//  NSDictionary+animes.m
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "NSDictionary+animes.h"

@implementation NSDictionary (animes)

- (NSNumber *)idAnime
{
    NSString *cc = self[@"series_animedb_id"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)title
{
    return self[@"series_title"];
}

- (NSNumber *)idStatus
{
    NSString *cc = self[@"series_status"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)idType
{
    NSString *cc = self[@"series_type"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)episodes
{
    NSString *cc = self[@"series_episodes"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)idMyStatus
{
    NSString *cc = self[@"my_status"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)watchedEpisodes
{
    NSString *cc = self[@"my_watched_episodes"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)urlThumbnail
{
    return self[@"series_image"];    
}

- (NSString *)descStatus
{
    NSString *descr = @"?";
    NSString *cc = self[@"series_status"];
    switch ([cc intValue]) {
        case 1:
            descr = @"In Progress";
            break;
        case 2:
            descr = @"Finalized";
            break;
        case 3:
            descr = @"Not yet aired";
            break;
        default:
            break;
    }
    return descr;
}
- (NSString *)descType
{
    NSString *descr = @"?";
    NSString *cc = self[@"series_type"];
    switch ([cc intValue]) {
        case 1:
            descr = @"TV";
            break;
        case 2:
            descr = @"OVA";
            break;
        case 3:
            descr = @"Movie";
            break;
        case 4:
            descr = @"Special";
            break;
        case 5:
            descr = @"ONA";
            break;
        case 6:
            descr = @"Music";
            break;
        default:
            break;
    }
    return descr;
}
- (NSString *)descMyStatus
{
    NSString *descr = @"?";
    NSString *cc = self[@"my_status"];
    switch ([cc intValue]) {
        case 1:
            descr = @"Watching";
            break;
        case 2:
            descr = @"Completed";
            break;
        case 3:
            descr = @"On Hold";
            break;
        case 4:
            descr = @"Dropped";
            break;
        case 6:
            descr = @"Plan To Watch";
            break;
        default:
            break;
    }
    return descr;
}
- (NSString *)descEpisodes
{
    NSString *epi = self[@"series_episodes"];
    NSString *myEpi = self[@"my_watched_episodes"];
    if ([epi isEqualToString:@"0"]){
        epi = @"?";
    }
    if ([myEpi isEqualToString:@"0"]){
        myEpi = @"?";
    }
    return [[myEpi stringByAppendingString:@" / "] stringByAppendingString:epi];
}
@end
