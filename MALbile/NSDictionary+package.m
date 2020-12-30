//
//  NSDictionary+package.m
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "NSDictionary+package.h"

@implementation NSDictionary (package)
-(NSDictionary *)myInfo
{
    NSDictionary *dict = self[@"data"];
    NSArray *ar = dict[@"myinfo"];
    return ar[0];
}
-(NSArray *)anime
{
    NSDictionary *dict = self[@"data"];
    return dict[@"anime"];
}
-(NSArray *)manga
{
    NSDictionary *dict = self[@"data"];
    return dict[@"manga"];
}
-(NSArray *)animeSearch
{
    NSDictionary *dict = self[@"data"];
    return dict[@"entry"];
}
-(NSArray *)mangaSearch
{
    NSDictionary *dict = self[@"data"];
    return dict[@"entry"];
}
@end
