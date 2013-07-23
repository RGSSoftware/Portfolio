//
//  RGSVideoViewControllerManger.m
//  Portfolio
//
//  Created by PC on 6/7/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSVideoViewControllerManger.h"
#import "RGSVideoViewController.h"

#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"

#import "SDSegmentedControl.h"

#import <Parse/Parse.h>
float const categoryControlX = 0;
float const categoryControlY = 0;
float const categoryControlHeight = 35.f;

float const categoryVideosViewX = 0;
float const categoryVideosViewY = categoryControlHeight;

@interface RGSVideoViewControllerManger ()

@property(nonatomic, strong)MenuBarButtons *menuBarButtons;
@property(nonatomic, strong)SDSegmentedControl *segmentedControl;

@property(nonatomic, strong)NSMutableArray *videoViewControllers;
@property(nonatomic, strong)NSArray *videoCategories;

@property(nonatomic, weak)UIViewController *currentViewCategoryController;

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

-(NSArray *)downloadCategories
{
    PFQuery *query = [PFQuery queryWithClassName:@"youTubeChannels"];
    NSArray *objects = [query findObjects];
    
    
    NSMutableArray *categories = [NSMutableArray array];
    for (PFObject *object in objects) {
        NSMutableDictionary *category = [NSMutableDictionary new];
        [categories addObject:category];
        
        [category setObject:[object objectForKey:@"title"] forKey:@"title"];
        [category setObject:[object objectForKey:@"ID"] forKey:@"ID"];
        
        NSLog(@"Downloading catorgies!!!!!!!!");
        
    }
    
    return categories;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Videos";
    
    self.view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    //self.tableView.backgroundView.backgroundColor = [UIColor brownColor];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _videoCategories = [self downloadCategories];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!_videoViewControllers) {
                    _videoViewControllers = [NSMutableArray new];
        
                for (int i = 0; i < [_videoCategories count]; i++) {
                    [_videoViewControllers addObject:[self videoViewControllerWithCategory:[_videoCategories objectAtIndex:i]]];
                }
            }
            
            _currentViewCategoryController = [_videoViewControllers objectAtIndex:0];
            _currentViewCategoryController.view.frame = CGRectMake(categoryVideosViewX, categoryVideosViewY, self.view.frame.size.width, self.view.frame.size.height-categoryVideosViewY);
            [self addChildViewController:_currentViewCategoryController];
            [self.view addSubview:_currentViewCategoryController.view];
            [self.view sendSubviewToBack:_currentViewCategoryController.view];
            [_currentViewCategoryController didMoveToParentViewController:self];
            
        });
    });
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
    
    _segmentedControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Music Videos", @"Comedy Skits", nil]];
    _segmentedControl.arrowHeightFactor *= -1.0;
    _segmentedControl.interItemSpace = 5;
    [_segmentedControl addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.frame = CGRectMake(categoryControlX, categoryControlY, self.view.frame.size.width, categoryControlHeight);
    [self.view addSubview:_segmentedControl];
    [self.view bringSubviewToFront:_segmentedControl];

}

- (RGSVideoViewController *)videoViewControllerWithCategory:(NSDictionary *)category
{
    
    RGSVideoViewController *videoController = [RGSVideoViewController new];
    videoController.channelID = [category objectForKey:@"ID"];
   return videoController;
}

-(void)changeCategory
{
    [_currentViewCategoryController willMoveToParentViewController:nil];
    [_currentViewCategoryController.view removeFromSuperview];
    [_currentViewCategoryController removeFromParentViewController];
    
    _currentViewCategoryController = [_videoViewControllers objectAtIndex:_segmentedControl.selectedSegmentIndex];
    _currentViewCategoryController.view.frame = CGRectMake(categoryVideosViewX, categoryVideosViewY, self.view.frame.size.width, self.view.frame.size.height-categoryVideosViewY);
    [self addChildViewController:_currentViewCategoryController];
    [self.view addSubview:_currentViewCategoryController.view];
    [self.view sendSubviewToBack:_currentViewCategoryController.view];
    [_currentViewCategoryController didMoveToParentViewController:self];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [_menuBarButtons.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [_menuBarButtons setupMenuBarButtonItems];
    }];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [_menuBarButtons.menuContainerViewController toggleRightSideMenuCompletion:^{
        [_menuBarButtons setupMenuBarButtonItems];
    }];
}


@end
