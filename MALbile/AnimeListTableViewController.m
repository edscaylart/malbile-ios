//
//  AnimeListTableViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "AnimeListTableViewController.h"
#import "AnimeListTableViewCell.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+animes.h"
#import "NSDictionary+package.h"
#import "AnimeDetailTableViewController.h"

const NSString *BASE_URL_ANIME = @"http://myanimelist.net/malappinfo.php?u=";

@interface AnimeListTableViewController ()

@property(nonatomic,strong) NSMutableDictionary* currentDictionary;
@property(nonatomic,strong) NSMutableDictionary* xmlAnime;
@property(nonatomic,strong) NSString* elementName;
@property(nonatomic,strong) NSMutableString* outstring;
@property(strong) NSDictionary* animes;
@property(strong) NSDictionary* filteredAnimes;

@end

@implementation AnimeListTableViewController

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
    
    self.myStatusId = @1;
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
    [XMLParser parse];
    
}

- (void)getAnimeList {
    self.animes = nil;
    self.filteredAnimes = nil;

    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    NSString* string = [[NSString stringWithFormat:@"%@", BASE_URL_ANIME] stringByAppendingString:username];
    string = [string stringByAppendingString:@"&status=all&type=anime"];
    
    NSURL* url = [NSURL URLWithString:string];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [self carregarAnimes:responseObject];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
    NSArray *anime = [self.filteredAnimes anime];
    return [anime count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"AnimeCell";
    
    AnimeListTableViewCell *cell = (AnimeListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AnimeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *animeDict = nil;
    
    NSArray *anime = [self.filteredAnimes anime];
    animeDict = anime[indexPath.row];
    
    self.title = [@"Animes - " stringByAppendingString:[animeDict descMyStatus]];
    
    cell.aTitle.text = [animeDict title];
    cell.aType.text = [animeDict descType];
    cell.aStatus.text = [animeDict descStatus];
    cell.aEpisodes.text = [animeDict descEpisodes];
    
    [cell.aThumbnail sd_setImageWithURL:[NSURL URLWithString:[animeDict urlThumbnail]]
                           placeholderImage:[UIImage imageNamed:@"anime.png"]];
    
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AnimeDetailSegue"]){
        AnimeListTableViewCell *cell = (AnimeListTableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        AnimeDetailTableViewController *det = (AnimeDetailTableViewController *)segue.destinationViewController;
        
        det.animeDictionary = [self.filteredAnimes anime][indexPath.row];
    }
    else if([segue.identifier isEqualToString:@"StatusSegueMain"]){
        StatusTableViewController *status = (StatusTableViewController *)segue.destinationViewController;
        status.delegate = self;
        status.selectedId = self.myStatusId;
        status.descStatus = [NSArray arrayWithObjects:@"Watching",@"Completed",@"On Hold",@"Dropped",@"Plan To Watch", nil];
        status.idStatus = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"6", nil];
    }
}

- (void)addItemViewController:(StatusTableViewController *)controller didFinishEnteringItem:(NSString *)item
{    
    self.myStatusId = @([item intValue]);
    [self getAnimeList];
}

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    self.xmlAnime = [NSMutableDictionary dictionary];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.elementName = qName;
    
    if ([qName isEqualToString:@"anime"])
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
    if ([qName isEqualToString:@"anime"]) {
        NSMutableArray* array = self.xmlAnime[@"anime"] ?: [NSMutableArray array];
        
        [array addObject:self.currentDictionary];
        
        self.xmlAnime[@"anime"] = array;
        
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
    
    //filtrar animes
    NSMutableDictionary* animeFilter = [NSMutableDictionary dictionary];
    NSArray *anime = [self.animes anime];
    for (int i = 0; i < [anime count]; i++) {
        NSDictionary* compare = anime[i];
        if ([compare idMyStatus] == self.myStatusId) {
            NSMutableArray* array = animeFilter[@"anime"] ?: [NSMutableArray array];
            
            [array addObject:anime[i]];
            
            animeFilter[@"anime"] = array;
        }
    }
    self.filteredAnimes = @{@"data": animeFilter};
    NSLog(@"%d", [[self.filteredAnimes anime] count]);

    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender {
    [self getAnimeList];
}
@end
