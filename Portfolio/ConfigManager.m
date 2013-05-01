//
//  ConfigManager.m
//  Portfolio
//
//  Created by PC on 4/30/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "ConfigManager.h"
#import <Parse/Parse.h>

@implementation ConfigManager

-(id)init
{
    if ((self = [super init])) {
        [self downloadShortFilmsConfig];
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

-(void)downloadShortFilmsConfig
{
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"youtube"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"Succesfully retrieved config.");
            
            PFObject *object = objects[0];
            PFFile *file = [object objectForKey:@"file"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    _shortFilmsConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"shortFilmConfigFinishedLoading" object:nil];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
};

@end
