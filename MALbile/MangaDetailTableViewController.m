//
//  MangaDetailTableViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/19/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "MangaDetailTableViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

const NSString *MANGA_URL_UPDATE = @"http://myanimelist.net/api/mangalist/update/%@.xml";
const NSString *MANGA_URL_DELETE = @"http://myanimelist.net/api/mangalist/delete/%@.xml";


@interface MangaDetailTableViewController (){
    NSString *pstatus, *pchapters, *pvolumes;
}

@end

@implementation MangaDetailTableViewController

@synthesize lbTitle;
@synthesize thumbnail;
@synthesize type;
@synthesize myStatus;
@synthesize chapters;
@synthesize volumes;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.animeDictionary setValue:@"teste" forKey:@"series_title"];
    
    self.lbTitle.text = [self.mangaDictionary titleManga];
    self.type.text = [self.mangaDictionary descTypeManga];
    self.myStatus.text = [self.mangaDictionary descMyStatusManga];
    self.chapters.text = [self.mangaDictionary descChapters];
    self.volumes.text = [self.mangaDictionary descVolumes];
    [thumbnail sd_setImageWithURL:[NSURL URLWithString:[self.mangaDictionary urlThumbnail]]
                 placeholderImage:[UIImage imageNamed:@"manga.png"]];
    
    pstatus = [NSString stringWithFormat:@"%@",[self.mangaDictionary idMyStatusManga]];
    pchapters = [NSString stringWithFormat:@"%@",[self.mangaDictionary readChapters]];
    pvolumes = [NSString stringWithFormat:@"%@",[self.mangaDictionary readVolumes]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"StatusSegue"]){
        StatusTableViewController *status = (StatusTableViewController *)segue.destinationViewController;
        status.delegate = self;
        status.selectedId = [self.mangaDictionary idMyStatusManga];
        status.descStatus = [NSArray arrayWithObjects:@"Reading",@"Completed",@"On Hold",@"Dropped",@"Plan To Read", nil];
        status.idStatus = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"6", nil];
    }
}

- (void)addItemViewController:(StatusTableViewController *)controller didFinishEnteringItem:(NSString *)item
{
    [self.mangaDictionary setValue:item forKey:@"my_status"];
    self.myStatus.text = [self.mangaDictionary descMyStatusManga];
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
    if (![pchapters isEqualToString:@""]) {
        [XMLString appendString:@"<chapter>"];
        [XMLString appendString:pchapters];
        [XMLString appendString:@"</chapter>"];
    }
    if (![pvolumes isEqualToString:@""]) {
        [XMLString appendString:@"<volume>"];
        [XMLString appendString:pvolumes];
        [XMLString appendString:@"</volume>"];
    }
    [XMLString appendString:@"</entry>"];
    
    return XMLString;
}

- (IBAction)plusChapter:(id)sender {
    NSNumber *myChap = @([pchapters intValue]+1);
    NSNumber *chap = @([[self.mangaDictionary chapters] intValue]);
    if ([myChap intValue] <= [chap  intValue] || [chap  intValue] == 0) {
        pchapters = [NSString stringWithFormat:@"%@",myChap];
        
        [self.mangaDictionary setValue:pchapters forKey:@"my_read_chapters"];
        self.chapters.text = [self.mangaDictionary descChapters];
    }
}

- (IBAction)plusVolume:(id)sender {
    NSNumber *myVol = @([pvolumes intValue]+1);
    NSNumber *vol = @([[self.mangaDictionary volumes] intValue]);
    if ([myVol intValue] <= [vol  intValue] || [vol  intValue] == 0) {
        pvolumes = [NSString stringWithFormat:@"%@",myVol];
        
        [self.mangaDictionary setValue:pvolumes forKey:@"my_read_volumes"];
        self.volumes.text = [self.mangaDictionary descVolumes];
    }
}

- (IBAction)save:(id)sender {
    [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString* urlString = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",MANGA_URL_UPDATE], [self.mangaDictionary idManga]];
    
    
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

- (IBAction)deleteManga:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting Manga!" message:@"Are you sure that you want to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"YES"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
        
        NSString* urlString = [NSString stringWithFormat:[NSString stringWithFormat:@"%@",MANGA_URL_DELETE], [self.mangaDictionary idManga]];
        
        
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
