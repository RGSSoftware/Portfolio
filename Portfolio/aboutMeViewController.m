//
//  aboutMeViewController.m
//  Portfolio
//
//  Created by PC on 5/6/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "aboutMeViewController.h"
#import "ConfigManager.h"
#import <Parse/Parse.h>

#import "MenuBarButtons.h"

@interface aboutMeViewController ()

@property(nonatomic, strong)MenuBarButtons *menuBarButtons;

@end

@implementation aboutMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationItem.title = @"About Me";
    
    [self downloadedBioPhoto];
    [_bioText setText:[[[ConfigManager sharedManager] aboutMeConfig] objectForKey:@"bio"]];
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadedBioPhoto
{
    PFQuery *query = [PFQuery queryWithClassName:@"bioPicture"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            NSLog(@"%@", @"Successfully retrieved bio photo.");
            PFFile *file = [[objects objectAtIndex:0] objectForKey:@"pic"];
            _bioImage.file = file;
            [_bioImage loadInBackground];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
     
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
