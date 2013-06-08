//
//  RGSVideoViewControllerManger.m
//  Portfolio
//
//  Created by PC on 6/7/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSVideoViewControllerManger.h"
#import "videoViewController.h"

@interface RGSVideoViewControllerManger ()

@property(nonatomic, strong)NSMutableArray *videoViewControllers;
@property(nonatomic, strong)NSMutableArray *videoCategories;

@property(nonatomic, strong)UIViewController *currentVisibleViewController;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!_videoViewControllers) {
        _videoViewControllers = [NSMutableArray new];
        
        for (int i = 0; i < [_videoCategories count]; i++) {
            [_videoViewControllers addObject:[self videoViewControllerWithVideoIDs:[_videoCategories objectAtIndex:i]]];
        }
        self.navigationController.viewControllers = [_videoViewControllers objectAtIndex:1];
    }
    
    
    
}
- (videoViewController *)videoViewControllerWithVideoIDs:(NSArray *)videoIDs
{
    
    
   // return [videoViewController new];
}

- (void)videoViewController:(videoViewController *)videoViewController shouldChangeToCategory:(int)category
{
    
    self.navigationController.viewControllers = [_videoViewControllers objectAtIndex:category];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
