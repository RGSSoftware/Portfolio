//
//  ContactViewController.m
//  Portfolio
//
//  Created by PC on 5/2/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

    @property(nonatomic, strong)NSDictionary *config;
@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"contactConfig" ofType:@"plist"];
        _config = [[NSDictionary alloc] initWithContentsOfFile:path];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}
- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *emailController = [MFMailComposeViewController new];
    emailController.mailComposeDelegate = self;
    [emailController setSubject:@"Helpppppp!!!!"];
        [self presentModalViewController:emailController animated:YES];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (IBAction)facebook:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[[_config objectForKey:@"contactInfo"] objectForKey:@"facebook"]];
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}
@end
