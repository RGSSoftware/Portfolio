//
//  ContactViewController.m
//  Portfolio
//
//  Created by PC on 5/2/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "ContactViewController.h"
#import "ConfigManager.h"
#import "MFSideMenu.h"

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
       
        [self setupMenuBarButtonItems];
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
    
    [self dismissViewControllerAnimated:YES completion:Nil];
    
}
- (IBAction)email:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *emailController = [MFMailComposeViewController new];
    emailController.mailComposeDelegate = self;
    [emailController setToRecipients:[NSArray arrayWithObject:[[[[ConfigManager sharedManager] contactConfig] objectForKey:@"contactInfo"] objectForKey:@"emailAddress"]]];
    [emailController setSubject:@"Helpppppp!!!!"];
        [self presentViewController:emailController animated:YES completion:Nil];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (IBAction)facebook:(id)sender {
    
    NSURL *url = [NSURL URLWithString:[[[[ConfigManager sharedManager] contactConfig] objectForKey:@"contactInfo"] objectForKey:@"facebook"]];
    
    if (![[UIApplication sharedApplication] openURL:url])
    {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

-(void)setupMenuBarButtonItems {
    switch (self.navigationController.sideMenu.menuState) {
        case MFSideMenuStateClosed:
            if([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
                self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            } else {
                self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
            }
            //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
        case MFSideMenuStateLeftMenuOpen:
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            break;
        case MFSideMenuStateRightMenuOpen:
            //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self.navigationController.sideMenu
            action:@selector(toggleLeftSideMenu)];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(backButtonPressed:)];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
