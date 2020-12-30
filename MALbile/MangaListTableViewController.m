//
//  MangaListTableViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/19/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "MangaListTableViewController.h"
#import "MangaListTableViewCell.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "NSDictionary+mangas.h"
#import "NSDictionary+package.h"
#import "MangaDetailTableViewController.h"

const NSString *BASE_URL_MANGA= @"http://myanimelist.net/malappinfo.php?u=";

@interface MangaListTableViewController ()

@property(nonatomic,strong) NSMutableDictionary* currentDictionary;
@property(nonatomic,strong) NSMutableDictionary* xmlManga;
@property(nonatomic,strong) NSString* elementName;
@property(nonatomic,strong) NSMutableString* outstring;
@property(strong) NSDictionary* mangas;
@property(strong) NSDictionary* filteredMangas;

@end

@implementation MangaListTableViewController

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
    [self getMangaList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)carregarMangas: (NSXMLParser*) xml {
    NSXMLParser* XMLParser = (NSXMLParser*) xml;
    [XMLParser setShouldProcessNamespaces:YES];
    
    XMLParser.delegate = self;
    [XMLParser parse];    
}

- (void)getMangaList {
    self.mangas = nil;
    self.filteredMangas = nil;
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    NSString* string = [[NSString stringWithFormat:@"%@", BASE_URL_MANGA] stringByAppendingString:username];
    string = [string stringByAppendingString:@"&status=all&type=manga"];
    
    NSURL* url = [NSURL URLWithString:string];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self carregarMangas:responseObject];
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
    NSArray *manga = [self.filteredMangas manga];
    return [manga count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MangaCell";
    
    MangaListTableViewCell *cell = (MangaListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MangaCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary *mangaDict = nil;
    
    NSArray *manga = [self.filteredMangas manga];
    mangaDict = manga[indexPath.row];
    
    self.title = [@"Mangas - " stringByAppendingString:[mangaDict descMyStatusManga]];
    
    cell.aTitle.text = [mangaDict titleManga];
    cell.aType.text = [mangaDict descTypeManga];
    cell.aStatus.text = [mangaDict descStatusManga];
    cell.aChapters.text = [mangaDict descChapters];
    
    [cell.aThumbnail sd_setImageWithURL:[NSURL URLWithString:[mangaDict urlThumbnail]]
                       placeholderImage:[UIImage imageNamed:@"manga.png"]];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"MangaDetailSegue"]){
        MangaListTableViewCell *cell = (MangaListTableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        MangaDetailTableViewController *det = (MangaDetailTableViewController *)segue.destinationViewController;
        
        det.mangaDictionary = [self.filteredMangas manga][indexPath.row];
    }
    else if([segue.identifier isEqualToString:@"StatusSegueMain2"]){
        StatusTableViewController *status = (StatusTableViewController *)segue.destinationViewController;
        status.delegate = self;
        status.selectedId = self.myStatusId;
        status.descStatus = [NSArray arrayWithObjects:@"Reading",@"Completed",@"On Hold",@"Dropped",@"Plan To Read", nil];
        status.idStatus = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"6", nil];
    }
}

- (void)addItemViewController:(StatusTableViewController *)controller didFinishEnteringItem:(NSString *)item
{
    self.myStatusId = @([item intValue]);
    [self getMangaList];
}

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
    self.xmlManga = [NSMutableDictionary dictionary];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.elementName = qName;
    
    if ([qName isEqualToString:@"manga"])
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
    if ([qName isEqualToString:@"manga"]) {
        NSMutableArray* array = self.xmlManga[@"manga"] ?: [NSMutableArray array];
        
        [array addObject:self.currentDictionary];
        
        self.xmlManga[@"manga"] = array;
        
        self.currentDictionary = nil;
    }
    else if (qName) {
        self.currentDictionary[qName] = self.outstring;
    }
    
    self.elementName = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.mangas = @{@"data": self.xmlManga};
    
    //filtrar animes
    NSMutableDictionary* mangaFilter = [NSMutableDictionary dictionary];
    NSArray *manga = [self.mangas manga];
    for (int i = 0; i < [manga count]; i++) {
        NSDictionary* compare = manga[i];
        if ([compare idMyStatusManga] == self.myStatusId) {
            NSMutableArray* array = mangaFilter[@"manga"] ?: [NSMutableArray array];
            
            [array addObject:manga[i]];
            
            mangaFilter[@"manga"] = array;
        }
    }
    self.filteredMangas = @{@"data": mangaFilter};
    NSLog(@"%d", [[self.filteredMangas manga] count]);
    
    [self.tableView reloadData];
}

- (IBAction)refresh:(id)sender {
    [self getMangaList];
}
@end
