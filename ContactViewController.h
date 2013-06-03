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

typedef enum {
    ContactButtonYoutube,
    ContactButtonTwitter,
    ContactButtonFacebook,
    ContactButtonEmail,
}ContactButton;

@interface ContactViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;

@property (strong, nonatomic) IBOutlet UIButton *youtubeButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;

- (IBAction)callSafari:(id)sender;

- (IBAction)email:(id)sender;


@end
