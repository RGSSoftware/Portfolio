//
//  aboutMeViewController.h
//  Portfolio
//
//  Created by PC on 5/6/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AboutMeViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet PFImageView *bioImage;
@property (strong, nonatomic) IBOutlet UITextView *bioText;

@end
