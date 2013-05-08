//
//  ContactViewController.h
//  Portfolio
//
//  Created by PC on 5/2/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)email:(id)sender;

- (IBAction)facebook:(id)sender;
@end
