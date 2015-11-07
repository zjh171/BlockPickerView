//
//  AppDelegate.m
//  BlockPickerViewSample
//
//  Created by zhujinhui on 15/10/4.
//  Copyright © 2015年 kyson. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    self.window.rootViewController =navigationController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


@end
