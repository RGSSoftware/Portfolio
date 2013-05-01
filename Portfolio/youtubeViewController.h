//
//  FirstViewController.h
//  youtube
//
//  Created by PC on 2/21/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MFSideMenuController.h"



#define kAPIKEY "AIzaSyD1zIG_HErAICBi355-nPLzaxdAY71egIQ"

@interface youtubeViewController : UITableViewController
{
    NSMutableArray *_videoCategories;
}


@property (retain, nonatomic) IBOutlet UIWebView *video1;
@property (retain, nonatomic) IBOutlet UIWebView *video2;
@property (strong, nonatomic) IBOutlet UIWebView *video3;
@property (strong, nonatomic) IBOutlet UIWebView *video4;
@property (strong, nonatomic) IBOutlet UIWebView *video5;
@property (strong, nonatomic) IBOutlet UIWebView *video6;

@property(strong, nonatomic) UISegmentedControl *segmentedControl;

- (void)embedYouTube:(NSString *)urlString view:(UIWebView *)view;
@end
