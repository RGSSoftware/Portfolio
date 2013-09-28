//
//  InfoViewController.m
//  Portfolio
//
//  Created by PC on 6/2/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "InfoViewController.h"
#import "STViewController.h"

#import "MFSideMenu/MFSideMenu.h"
#import "MenuBarButtons.h"

@interface InfoViewController ()
@property (strong,nonatomic) MenuBarButtons *menuBarButtons;

@end

@implementation InfoViewController

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
   
    self.navigationItem.title = @"Info";
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Thanks:(id)sender {
    [self.navigationController pushViewController:[STViewController new] animated:YES];
    //[self presentViewController:[STViewController new] animated:YES completion:Nil];
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
