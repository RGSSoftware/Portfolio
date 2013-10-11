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

#import "splashScreenViewController.h"
#import "VideoViewControllerContainer.h"
#import "SideMenuViewController.h"

#import "MFSideMenu/MFSideMenu.h"

#import "LanchViewController.h"


@implementation RGSAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Register for push notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
                                                    UIRemoteNotificationTypeAlert |
                                                    UIRemoteNotificationTypeSound];

    
    [Parse setApplicationId:@"bUzh4WAVsJVI2tlaoAbgukS5WjnJe4vbiTd0Z95x"
                  clientKey:@"aqZdOO1BE4XplvkcznHtIf8mMKADxbePH3lwhGKx"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    splashScreenViewController *splashSreenController = [splashScreenViewController new];
    
    self.window.rootViewController = splashSreenController;
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConfigManagerDidStartConfigDownloadNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [MBProgressHUD showHUDAddedTo:splashSreenController.view animated:YES];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConfigManagerDidFailConfigDownloadNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                               
                                                        UIView *noInternetView = [self noInternetView];
                                                      
                                                        [splashSreenController.view addSubview:noInternetView];
                                                      
                                                        [UIView animateWithDuration:1.5
                                                                         animations:^{
                                                                             noInternetView.frame = CGRectMake(0, 0, 320, 33);
                                                                         } completion:^(BOOL finished) {
                                                                             [MBProgressHUD hideAllHUDsForView: splashSreenController.view animated:YES];
                                                                         }];          
                                                    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:ConfigManagerDidCompleteConfigDownloadNotification
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
                                                      
                                                      container.edgesForExtendedLayout = UIRectEdgeNone;
                                                      [container setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
                                                    
                                                      [self.window.rootViewController presentViewController:container animated:YES completion:Nil];
                                                  }];
    
    
    [ConfigManager sharedManager];

    return YES;
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error in registration. Error: %@", [error localizedDescription]);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //Store the deviceToken in the current installion and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
    
    int notificationNumber = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    
    application.applicationIconBadgeNumber = notificationNumber - 1;
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    //updates Parse to clear icon badge
    PFInstallation *currentInstallion = [PFInstallation currentInstallation];
    if (currentInstallion != 0) {
        currentInstallion.badge = 0;
        [currentInstallion saveEventually];
    }
}

- (UINavigationController *)navigationController
{
    VideoViewControllerContainer *viewController = [VideoViewControllerContainer new];
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:viewController];
    
    return navigationController;
}

-(UIView *)noInternetView
{
    UIView *noInternetView = [[UIView alloc] initWithFrame:CGRectMake(0, -33, 320, 33)];
    noInternetView.backgroundColor = [UIColor colorWithRed:.177/.255 green:0 blue:0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:19]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"No Internet Connective"];
    
    [noInternetView addSubview:label];
    
    return noInternetView;
    
}



- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"portfolioCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
