//
//  NSDictionary+search.m
//  MALbile
//
//  Created by Edson Souza on 10/22/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "NSDictionary+search.h"

@implementation NSDictionary (search)

- (NSNumber *)idSearch
{
    NSString *cc = self[@"id"];
    NSNumber *n = @([cc intValue]);
    return n;
}

- (NSString *)titleSearch
{
    return self[@"title"];
}

- (NSString *)statusSearch
{
    return self[@"status"];
}

- (NSString *)typeSearch
{
    return self[@"type"];
}

- (NSString *)episodesSearch
{
    return self[@"episodes"];
}

- (NSString *)chaptersSearch
{
    return self[@"chapters"];
}

- (NSString *)volumesSearch
{
    return self[@"volumes"];
}
- (NSString *)urlThumbnailSearch
{
    return self[@"image"];
}

@end
