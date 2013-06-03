//
//  RGSAppDelegate.m
//  Portfolio
//
//  Created by PC on 2/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSAppDelegate.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

#import "ConfigManager.h"
#import "GalleryViewControllerManger.h"

#import "videoViewController.h"
#import "ContactViewController.h"
#import "aboutMeViewController.h"

#import "GalleryViewController.h"
#import "SideMenuViewController.h"

#import "MFSideMenu.h"
  


@implementation RGSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [Parse setApplicationId:@"bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x"
                  clientKey:@"aqZdOO1BE4XplvkcznHtIf8mMKADxbePH3lwhGKx"];
    
   [ConfigManager sharedManager];
    
    UIViewController *splashSreenController = [self splashScreenController];
    [MBProgressHUD showHUDAddedTo:splashSreenController.view animated:YES];
    self.window.rootViewController = splashSreenController;
    
    [self.window makeKeyAndVisible];
    
     [[NSNotificationCenter defaultCenter] addObserverForName:@"ConfigManagerDidCompleteConfigDownloadNotification"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [MBProgressHUD hideAllHUDsForView:splashSreenController.view animated:YES];
                                                      
                                                      SideMenuViewController *leftMenuViewController = [[SideMenuViewController alloc] init];
                                                      MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                                                                      containerWithCenterViewController:[self navigationController]
                                                                                                      leftMenuViewController:leftMenuViewController
                                                                                                      rightMenuViewController:Nil];
                                                      
                                                      container.menuWidth = 80.0f;
                                                       self.window.rootViewController = container;
                                                      [self.window makeKeyAndVisible];
                                                  }];
    
    
    
    return YES;
}

- (UINavigationController *)navigationController
{
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:[videoViewController new]];
    
    return navigationController;
}

-(UIViewController *)splashScreenController
{
     UIViewController *splashScreen = [UIViewController new];
    splashScreen.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wide_rectangles.png"]];
    UIImageView *mainLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 50.f, self.window.bounds.size.width-20, 120.f)];
    mainLogo.image = [UIImage imageNamed:@"JVO-logo.png"];
    [splashScreen.view addSubview:mainLogo];
    
    return splashScreen;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
