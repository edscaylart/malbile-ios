//
//  AnimeDetailTableViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "AnimeDetailTableViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

const NSString *ANIME_URL_UPDATE = @"http://myanimelist.net/api/animelist/update/%@.xml";
const NSString *ANIME_URL_DELETE = @"http://myanimelist.net/api/animelist/delete/%@.xml";

@interface AnimeDetailTableViewController () {
    NSString *pstatus, *pepisode;
}

@end

@implementation AnimeDetailTableViewController

@synthesize lbTitle;
@synthesize thumbnail;
@synthesize type;
@synthesize myStatus;
@synthesize episodes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.animeDictionary setValue:@"teste" forKey:@"series_title"];
    
    self.lbTitle.text = [self.animeDictionary title];
    self.type.text = [self.animeDictionary descType];
    self.myStatus.text = [self.animeDictionary descMyStatus];
    self.episodes.text = [self.animeDictionary descEpisodes];
    [thumbnail sd_setImageWithURL:[NSURL URLWithString:[self.animeDictionary urlThumbnail]]
                       placeholderImage:[UIImage imageNamed:@"anime.png"]];
    
    pstatus = [NSString stringWithFormat:@"%@",[self.animeDictionary idMyStatus]];
    pepisode = [NSString stringWithFormat:@"%@",[self.animeDictionary watchedEpisodes]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"StatusSegue"]){
        StatusTableViewController *status = (StatusTableViewController *)segue.destinationViewController;
        status.delegate = self;
        status.selectedId = [self.animeDictionary idMyStatus];
        status.descStatus = [NSArray arrayWithObjects:@"Watching",@"Completed",@"On Hold",@"Dropped",@"Plan To Watch", nil];
        status.idStatus = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"6", nil];
    }
}

- (void)addItemViewController:(StatusTableViewController *)controller didFinishEnteringItem:(NSString *)item
{
    [self.animeDictionary setValue:item forKey:@"my_status"];
    self.myStatus.text = [self.animeDictionary descMyStatus];
    pstatus = item;
}

- (NSString*)createData
{
    NSMutableString *XMLString = [[NSMutableString alloc] init];
    [XMLString appendString:@"<?xml version=\"1.0\"?><entry>"];
    if (![pstatus isEqualToString:@""]) {
        [XMLString appendString:@"<status>"];
        [XMLString appendString:pstatus];
        [XMLString appendString:@"</status>"];
    }
    if (![pepisode isEqualToString:@""]) {
        [XMLString appendString:@"<episode>"];
        [XMLString appendString:pepisode];
        [XMLString appendString:@"</episode>"];
    }
    [XMLString appendString:@"</entry>"];
    
    return XMLString;
}

- (IBAction)plusEpisode:(id)sender {
    NSNumber *myEpi = @([pepisode intValue]+1);
    NSNumber *epi = @([[self.animeDictionary episodes] intValue]);
    if ([myEpi intValue] <= [epi  intValue]) {
        pepisode = [NSString stringWithFormat:@"%@",myEpi];
    
        [self.animeDictionary setValue:pepisode forKey:@"my_watched_episodes"];
        self.episodes.text = [self.animeDictionary descEpisodes];
    }
}

- (IBAction)save:(id)sender {
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString* urlString = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",ANIME_URL_UPDATE], [self.animeDictionary idAnime]];
    
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[self createData] forKey:@"data"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [manager POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"ok %@",responseObject);
        [SVProgressHUD dismiss];
        [self alert:@"Successful update!" :@"Updated" :0];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"Erro %@",error);
        [self alert:@"Unsuccessful update." :@"Update Failed" :0];
    }];

}

- (IBAction)deleteAnime:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting Anime!" message:@"Are you sure that you want to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"YES"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
        
        NSString* urlString = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",ANIME_URL_DELETE], [self.animeDictionary idAnime]];
        
        
        NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[self createData] forKey:@"data"];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:username password:password];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        [manager POST:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"ok %@",responseObject);
            [SVProgressHUD dismiss];
            [self alert:@"Successful delete!" :@"Deleted" :0];
            [self.navigationController popViewControllerAnimated:NO];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"Erro %@",error);
            [self alert:@"Unsuccessful delete." :@"Delete Failed" :0];
        }];
    }
}

- (void) alert:(NSString *)msg :(NSString*)title :(int)tag {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

@end
