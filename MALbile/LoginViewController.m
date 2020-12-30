//
//  LoginViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

const NSString *BASE_URL_LOGIN = @"http://myanimelist.net/api/account/verify_credentials.xml";

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize username;
@synthesize password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //[self setUsername:nil];
    //[self setPassword:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    return;
}

- (BOOL) validCredentials
{
    if ([self.username.text isEqualToString:@""]){
        return NO;
    }
    if ([self.password.text isEqualToString:@""]){
        return NO;
    }
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signin:(id)sender {
    if (![self validCredentials])
    {
        [self alert:@"Please enter username and password" :@"Sign In Failed" :0];
    } else {
        [SVProgressHUD showWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
        
        NSString* string = [NSString stringWithFormat:@"%@", BASE_URL_LOGIN];
        
        NSURL* url = [NSURL URLWithString:string];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username.text password:self.password.text persistence:NSURLCredentialPersistenceNone];
        
        AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.credential = credential;
        
        operation.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"ok %@",responseObject);
            [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"LoginMain" sender:self];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"Erro %@",error);
            [self alert:@"Wrong username or password" :@"Sign In Failed" :0];
        }];
        
        [operation start];
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

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
@end
