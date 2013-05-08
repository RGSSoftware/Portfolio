//
//  ConfigManager.m
//  Portfolio
//
//  Created by PC on 4/30/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "ConfigManager.h"
#import <Parse/Parse.h>
#import <dispatch/dispatch.h>

@implementation ConfigManager

-(id)init
{
    if ((self = [super init])) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            _shortFilmsConfig = [self downloadedShortFilmsConfig];
            _contactConfig = [self downloadedContactConfig];
            _aboutMeConfig = [self downloadedAboutMeConfig];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfigsFinishedDownLoading" object:nil];
            });
        });
        
       
    }
    return self;
}

+ (ConfigManager *)sharedManager
{
    static ConfigManager *sharedManager = nil;
    if (sharedManager == nil)
    {
        sharedManager = [[ConfigManager alloc] init];
    }
    return sharedManager;
}

-(id)downloadedShortFilmsConfig
{
    NSDictionary *shortFilmsConfig = [NSDictionary new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"youtube"];
    
    NSArray *objects = [query findObjects];
    PFFile *file = [[objects objectAtIndex:0] objectForKey:@"file"];
    NSData *data = [file getData];
    
    NSLog(@"Succesfully retrieved Youtube config.");
    shortFilmsConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return shortFilmsConfig;
    
};

-(id)downloadedContactConfig
{
    NSDictionary *contactConfig = [NSDictionary new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"contact"];
    
    NSArray *objects = [query findObjects];
    PFFile *file = [[objects objectAtIndex:0] objectForKey:@"file"];
    NSData *data = [file getData];
    
    NSLog(@"Succesfully retrieved Contact config.");
    contactConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return contactConfig;

};

-(id)downloadedAboutMeConfig
{
    NSDictionary *aboutMeConfig = [NSDictionary new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"aboutMe"];
    
    NSArray *objects = [query findObjects];
    PFFile *file = [[objects objectAtIndex:0] objectForKey:@"file"];
    NSData *data = [file getData];
    
    NSLog(@"Succesfully retrieved AboutMe config.");
    aboutMeConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return aboutMeConfig;
    
};
@end
