//
//  MFSideMenuDelegate.h
//  Portfolio
//
//  Created by PC on 3/4/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFSideMenuController : UIViewController

-(void)setupMenuBarButtonItems;
- (UIBarButtonItem *)leftMenuBarButtonItem;
- (UIBarButtonItem *)rightMenuBarButtonItem;
- (UIBarButtonItem *)backBarButtonItem;
- (void)backButtonPressed:(id)sender;

@end
