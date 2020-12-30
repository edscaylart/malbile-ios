//
//  SplashViewController.m
//  MALbile
//
//  Created by Edson Souza on 10/12/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(fechar) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fechar
{
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    if (username == nil)
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"MainSegue" sender:self];
    }
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

@end
