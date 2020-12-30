//
//  CustomSegue.m
//  MALbile
//
//  Created by Edson Souza on 10/11/14.
//  Copyright (c) 2014 UNISINOS. All rights reserved.
//

#import "CustomSegue.h"	
#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation CustomSegue

- (void)perform
{
    if ([self.identifier isEqualToString:@"LoginMain"])
    {
        LoginViewController* login = (LoginViewController*) self.sourceViewController;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:login.username.text forKey:@"username"];
        [prefs setObject:login.password.text forKey:@"password"];
        [prefs synchronize];
    }
    
    //Faz com que a view anterior seja destruida e nao fique ocupando memoria do dispositivo
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    app.window.rootViewController = dst;
}

@end
