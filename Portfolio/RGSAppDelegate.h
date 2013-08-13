//
//  RGSAppDelegate.h
//  Portfolio
//
//  Created by PC on 2/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>


@class RGSViewController;

@interface RGSAppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@property (strong, nonatomic) UIWindow *window;



@end
