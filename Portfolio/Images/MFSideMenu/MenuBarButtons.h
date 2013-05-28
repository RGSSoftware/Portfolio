//
//  MenuBarButtons.h
//  MFSideMenuDemoBasic
//
//  Created by PC on 5/27/13.
//  Copyright (c) 2013 University of Wisconsin - Madison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFSideMenuContainerViewController.h"

@protocol MenuBarButtonsProtocol <NSObject>

-(void)backButtonPressed:(id)sender;

@optional
-(void)leftSideMenuButtonPressed:(id)sender;
-(void)rightSideMenuButtonPressed:(id)sender;

@end

@interface MenuBarButtons : NSObject

@property(nonatomic, weak)UIViewController *parentController;
@property(nonatomic)BOOL setLeftBarButton;
@property(nonatomic)BOOL setRightBarButton;

-(id)initWithParentController:(UIViewController *)pcontroller;
-(MFSideMenuContainerViewController *)menuContainerViewController;
-(void)setupMenuBarButtonItems;
@end
