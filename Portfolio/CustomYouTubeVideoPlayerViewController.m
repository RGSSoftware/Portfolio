//
//  CustomYouTubeVideoPlayerViewController.m
//  RestKit
//
//  Created by PC on 8/7/13.
//  Copyright (c) 2013 RestKit. All rights reserved.
//

#import "CustomYouTubeVideoPlayerViewController.h"

#import "ConfigManager.h"

@interface CustomYouTubeVideoPlayerViewController ()

@end

@implementation CustomYouTubeVideoPlayerViewController

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
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:NavigationBarBackground] forBarMetrics:UIBarMetricsDefault];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

@end
