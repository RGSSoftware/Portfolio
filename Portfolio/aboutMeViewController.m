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

@interface aboutMeViewController ()

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
	// Do any additional setup after loading the view.
    // Custom initialization
    
    [self downloadedBioPhoto];
    [_bioText setText:[[[ConfigManager sharedManager] aboutMeConfig] objectForKey:@"bio"]];
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
@end
