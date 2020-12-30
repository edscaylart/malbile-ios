//
//  AnimeSearchListController.m
//  MALbile
//
//  Created by Edson Souza on 10/24/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "AnimeSearchListController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+search.h"
#import "NSDictionary+package.h"
#import "AnimeSearchCell.h"
#import "SearchTabBarController.h"

const NSString *URL_SEARCH_ANIME = @"http://myanimelist.net/api/anime/search.xml?q=";

@interface AnimeSearchListController ()

@property(nonatomic,strong) NSMutableDictionary* currentDictionary;
@property(nonatomic,strong) NSMutableDictionary* xmlAnime;
@property(nonatomic,strong) NSString* elementName;
@property(nonatomic,strong) NSMutableString* outstring;
@property(strong) NSDictionary* animes;

@end

@implementation AnimeSearchListController

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
        
    [self getAnimeList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)carregarAnimes: (NSXMLParser*) xml {
    NSXMLParser* XMLParser = (NSXMLParser*) xml;
    [XMLParser setShouldProcessNamespaces:YES];
    
    XMLParser.delegate = self;
    NSLog(@"%@", XMLParser);
    [XMLParser parse];
    
}

- (void)getAnimeList {
    self.animes = nil;
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    SearchTabBarController *tabBar = (SearchTabBarController*) self.tabBarController;
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString* password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    NSString* string = [[NSString stringWithFormat:@"%@", URL_SEARCH_ANIME] stringByAppendingString:tabBar.searchTitle];
    
    NSURL* url = [NSURL URLWithString:string];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username password:password persistence:NSURLCredentialPersistenceNone];

    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.credential = credential;
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer]; //AFXMLParserResponseSerializer
    
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"]; //application/rss+xml
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self carregarAnimes:responseObject];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [SVProgressHUD dismiss];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *anime = [self.animes animeSearch];
    return [anime count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AnimeSearchCell";
    
    AnimeSearchCell *cell = (AnimeSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnimeSearchCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *animeDict = nil;
    
    NSArray *anime = [self.animes animeSearch];
    animeDict = anime[indexPath.row];
    
    cell.aTitle.text = [animeDict titleSearch];
    cell.aType.text = [animeDict typeSearch];
    cell.aStatus.text = [animeDict statusSearch];
    cell.aEpisodes.text = [animeDict episodesSearch];
    
    [cell.aThumbnail sd_setImageWithURL:[NSURL URLWithString:[animeDict urlThumbnailSearch]]
                       placeholderImage:[UIImage imageNamed:@"animeSearch.png"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AnimeDetailSegue"]){
        AnimeSearchCell *cell = (AnimeSearchCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        //AnimeDetailTableViewController *det = (AnimeDetailTableViewController *)segue.destinationViewController;
        
        //det.animeDictionary = [self.filteredAnimes anime][indexPath.row];
    }
}

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    self.xmlAnime = [NSMutableDictionary dictionary];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.elementName = qName;
    
    if ([qName isEqualToString:@"entry"])
    {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
    self.outstring = [NSMutableString string];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.elementName)
        return;
    
    [self.outstring appendFormat:@"%@", string];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([qName isEqualToString:@"entry"]) {
        NSMutableArray* array = self.xmlAnime[@"entry"] ?: [NSMutableArray array];
        
        [array addObject:self.currentDictionary];
        
        self.xmlAnime[@"entry"] = array;
        
        self.currentDictionary = nil;
    }
    else if (qName) {
        self.currentDictionary[qName] = self.outstring;
    }
    
    self.elementName = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.animes = @{@"data": self.xmlAnime};
    
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);

}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
