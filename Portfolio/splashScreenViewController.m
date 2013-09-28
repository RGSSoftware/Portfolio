//
//  splashScreenViewController.m
//  JVO-Portfolio
//
//  Created by PC on 8/17/13.
//  Copyright (c) 2013 RandelSmith. All rights reserved.
//

#import "splashScreenViewController.h"

@interface splashScreenViewController ()

@end

@implementation splashScreenViewController

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wide_rectangles.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
