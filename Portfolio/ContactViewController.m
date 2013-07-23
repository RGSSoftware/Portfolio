//
//  ContactViewController.m
//  Portfolio
//
//  Created by PC on 5/2/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "ContactViewController.h"
#import "ConfigManager.h"
#import "MenuBarButtons.h"

@interface ContactViewController ()

@property(nonatomic, strong)NSDictionary *config;

@property(nonatomic, strong)MenuBarButtons *menuBarButtons;
@end

@implementation ContactViewController

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
    
    self.navigationItem.title = @"Contact";
    
    _config = [[ConfigManager sharedManager] contactConfig];
    
    _youtubeButton.tag = ContactButtonYoutube;
    _facebookButton.tag = ContactButtonFacebook;
    _twitterButton.tag = ContactButtonTwitter;
    _emailButton.tag = ContactButtonEmail;
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}
- (IBAction)callSafari:(id)sender {
    
    UIButton *button = sender;
    NSURL *url = [NSURL new];
    
    switch (button.tag) {
        case ContactButtonFacebook:
            url = [NSURL URLWithString:[[_config objectForKey:@"contactInfo"] objectForKey:@"facebook"]];
            break;
        case ContactButtonTwitter:
            url = [NSURL URLWithString:[[_config objectForKey:@"contactInfo"] objectForKey:@"twitter"]];
            break;
        case ContactButtonYoutube:
            url = [NSURL URLWithString:[[_config objectForKey:@"contactInfo"] objectForKey:@"youtube"]];
            break;
        default:
            break;
    }
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *emailController = [MFMailComposeViewController new];
    emailController.mailComposeDelegate = self;
    [emailController setToRecipients:[NSArray arrayWithObject:[[_config objectForKey:@"contactInfo"] objectForKey:@"emailAddress"]]];
    [emailController setSubject:@"Helpppppp!!!!"];
        [self presentViewController:emailController animated:YES completion:Nil];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
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
