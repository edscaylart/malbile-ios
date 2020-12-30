//
//  NSDictionary+mangas.m
//  MALbile
//
//  Created by Edson Souza on 10/19/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "NSDictionary+mangas.h"

@implementation NSDictionary (mangas)

- (NSNumber *)idManga
{
    NSString *cc = self[@"series_mangadb_id"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)titleManga
{
    return self[@"series_title"];
}

- (NSNumber *)idStatusManga
{
    NSString *cc = self[@"series_status"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)idTypeManga
{
    NSString *cc = self[@"series_type"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)chapters
{
    NSString *cc = self[@"series_chapters"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)volumes
{
    NSString *cc = self[@"series_volumes"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)idMyStatusManga
{
    NSString *cc = self[@"my_status"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)readChapters
{
    NSString *cc = self[@"my_read_chapters"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSNumber *)readVolumes
{
    NSString *cc = self[@"my_read_volumes"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)urlThumbnail
{
    return self[@"series_image"];
}

- (NSString *)descStatusManga
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
- (NSString *)descTypeManga
{
    NSString *descr = @"?";
    NSString *cc = self[@"series_type"];
    switch ([cc intValue]) {
        case 1:
            descr = @"Manga";
            break;
        case 2:
            descr = @"Novel";
            break;
        case 3:
            descr = @"One Shot";
            break;
        case 4:
            descr = @"Doujin";
            break;
        case 5:
            descr = @"Manwha";
            break;
        case 6:
            descr = @"Manhua";
            break;
        case 7:
            descr = @"OEL";
            break;

        default:
            break;
    }
    return descr;
}
- (NSString *)descMyStatusManga
{
    NSString *descr = @"?";
    NSString *cc = self[@"my_status"];
    switch ([cc intValue]) {
        case 1:
            descr = @"Reading";
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
            descr = @"Plan To Read";
            break;
        default:
            break;
    }
    return descr;
}
- (NSString *)descChapters
{
    NSString *chap = self[@"series_chapters"];
    NSString *myChap = self[@"my_read_chapters"];
    if ([chap isEqualToString:@"0"]){
        chap = @"?";
    }
    if ([myChap isEqualToString:@"0"]){
        myChap = @"?";
    }
    return [[myChap stringByAppendingString:@" / "] stringByAppendingString:chap];
}
- (NSString *)descVolumes
{
    NSString *vol = self[@"series_volumes"];
    NSString *myVol = self[@"my_read_volumes"];
    if ([vol isEqualToString:@"0"]){
        vol = @"?";
    }
    if ([myVol isEqualToString:@"0"]){
        myVol = @"?";
    }
    return [[myVol stringByAppendingString:@" / "] stringByAppendingString:vol];
}
@end
