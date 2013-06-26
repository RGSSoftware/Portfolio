//
//  RGSVideoViewControllerManger.m
//  Portfolio
//
//  Created by PC on 6/7/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSVideoViewControllerManger.h"
#import "RGSVideo2ViewController.h"
#import "videoViewController.h"

#import <Parse/Parse.h>
@interface RGSVideoViewControllerManger ()

@property(nonatomic, strong)NSMutableArray *videoViewControllers;
@property(nonatomic, strong)NSMutableArray *videoCategories;

@end

@implementation RGSVideoViewControllerManger

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)getDownloadedCategories
{
    PFQuery *query = [PFQuery queryWithClassName:@"youTubeChannels"];
    NSArray *objects = [query findObjects];
    
    NSMutableArray *categories = [NSMutableArray array];
    for (PFObject *object in objects) {
        NSMutableDictionary *category = [NSMutableDictionary new];
        [categories addObject:category];
        
        [category setObject:[object objectForKey:@"title"] forKey:@"title"];
        [category setObject:[object objectForKey:@"ID"] forKey:@"ID"];
        
        NSLog(@"channel title:%@", [object objectForKey:@"title"]);
    }
    
    return categories;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _videoCategories = [self getDownloadedCategories];
    
    if (!_videoViewControllers) {
        _videoViewControllers = [NSMutableArray new];
        
        for (int i = 0; i < [_videoCategories count]; i++) {
            [_videoViewControllers addObject:[self videoViewControllerWithCategory:[_videoCategories objectAtIndex:i]]];
        }
        self.navigationController.viewControllers = @[[_videoViewControllers objectAtIndex:0]];
    }
    
    
    
}
- (RGSVideo2ViewController *)videoViewControllerWithCategory:(NSDictionary *)category
{
    
    RGSVideo2ViewController *videoController = [RGSVideo2ViewController new];
    videoController.channelID = [category objectForKey:@"ID"];
   return videoController;
}

- (void)videoViewController:(videoViewController *)videoViewController shouldChangeToCategory:(int)category
{
    
    self.navigationController.viewControllers = @[[_videoViewControllers objectAtIndex:category]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
