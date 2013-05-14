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

#import "videoViewController.h"
#import "youtubeViewController.h"
#import "galleryViewController.h"
//#import "RGViewController.h"
#import "SideMenuViewController.h"
#import "ContactViewController.h"
#import "aboutMeViewController.h"
#import "MFSideMenu.h"

@implementation RGSAppDelegate

@synthesize window = _window;

- (galleryViewController *)demoController {
    return [galleryViewController new];
}

- (UINavigationController *)navigationController {
    return [[UINavigationController alloc]
            initWithRootViewController:[self demoController]];
}

- (MFSideMenu *)sideMenu {
    SideMenuViewController *leftSideMenuController = [[SideMenuViewController alloc] init];
    
    UINavigationController *navigationController = [self navigationController];
    
    
    MFSideMenu *sideMenu = [MFSideMenu menuWithNavigationController:navigationController
                                             leftSideMenuController:leftSideMenuController
                                            rightSideMenuController:nil];
    
    leftSideMenuController.sideMenu = sideMenu;
    
    
    return sideMenu;
}

- (void) setupNavigationControllerApp {
    self.window.rootViewController = [self sideMenu].navigationController;
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x"
                  clientKey:@"aqZdOO1BE4XplvkcznHtIf8mMKADxbePH3lwhGKx"];
    
   [ConfigManager sharedManager];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
       

    UIViewController *splashScreen = [UIViewController new];
    splashScreen.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wide_rectangles.png"]];
    UIImageView *mainLogo = [[UIImageView alloc] initWithFrame:CGRectMake(15.f, 50.f, self.window.bounds.size.width-20, 120.f)];
    mainLogo.image = [UIImage imageNamed:@"JVO-logo.png"];
    [splashScreen.view addSubview:mainLogo];
    //splashScreen.backgroundColor = [UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:splashScreen.view animated:YES];
    
    
    [self.window setRootViewController:splashScreen];
    //[self.window setRootViewController:[galleryViewController new]];
    [self.window makeKeyAndVisible];
    
     [[NSNotificationCenter defaultCenter] addObserverForName:@"ConfigsFinishedDownLoading"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [MBProgressHUD hideAllHUDsForView:splashScreen.view animated:YES];
                                                      
                                                      [self.window setRootViewController:[galleryViewController new]];
                                                      //[self setupNavigationControllerApp];
                                                  }];
    
    
    
    
    return YES;
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
