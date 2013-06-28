//
//  STViewController.m
//  Portfolio
//
//  Created by PC on 6/2/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "STViewController.h"
#import "MFSideMenu.h"
#import "MenuBarButtons.h"

@interface STViewController ()
@property (strong,nonatomic) MenuBarButtons *menuBarButtons;

@end

@implementation STViewController

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
    // Do any additional setup after loading the view from its nib.
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
    
    self.navigationItem.title = @"Thanks";

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
