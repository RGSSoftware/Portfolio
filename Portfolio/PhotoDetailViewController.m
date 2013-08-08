//
//  PhotoDetailViewController.m
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import "PhotoDetailViewController.h"

#import "MFSideMenuContainerViewController.h"

@implementation PhotoDetailViewController
@synthesize photoImageView, selectedImage, imageName;

//Close the view controller
- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.parentViewController;
    [container.navigationController.navigationBar setTintColor:nil];
    [container.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"red_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"red_background.png"] forBarMetrics:UIBarMetricsDefault];
    
    /*
    [self.navigationController.navigationBar setTintColor:Nil];
    [self.navigationController.navigationBar setBackgroundImage:Nil forBarMetrics:UIBarMetricsDefault];
    */
   
    
    self.photoImageView.image = selectedImage;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
