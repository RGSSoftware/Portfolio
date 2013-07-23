//
//  RGSVideo2ViewController.h
//  Portfolio
//
//  Created by PC on 6/11/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RGSVideoViewController : UITableViewController

@property(nonatomic, strong)NSString *channelID;
@property(nonatomic, strong)NSString *channelTitle;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end