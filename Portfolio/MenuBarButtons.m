//
//  MenuBarButtons.m
//  MFSideMenuDemoBasic
//
//  Created by PC on 5/27/13.
//  Copyright (c) 2013 University of Wisconsin - Madison. All rights reserved.
//

#import "MenuBarButtons.h"

#import "MFSideMenu/MFSideMenu.h"


@implementation MenuBarButtons

-(id)initWithParentController:(UIViewController *)pcontroller
{
    self = [super init];
    if (self) {
        _parentController = pcontroller;
        _setLeftBarButton = FALSE;
        _setRightBarButton = FALSE;
    }
    return self;
}

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)_parentController.navigationController.parentViewController;
}
- (void)setupMenuBarButtonItems {
    if (_setLeftBarButton) {
        if(self.menuContainerViewController.menuState == MFSideMenuStateClosed &&
           ![[_parentController.navigationController.viewControllers objectAtIndex:0] isEqual:_parentController]) {
            _parentController.navigationItem.leftBarButtonItem = [self backBarButtonItem];
        } else {
            _parentController.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
        }
    }
    
    if (_setRightBarButton) {
        _parentController.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
    }
    
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
     
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    if ([_parentController respondsToSelector:@selector(leftSideMenuButtonPressed:)]) {
        [barButton addTarget:_parentController action:@selector(leftSideMenuButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    } else NSLog(@"ERROR %@ did not respond to selector:(%@)", NSStringFromClass([_parentController class]), @"leftSideMenuButtonPressed:");

    [barButton setFrame:CGRectMake(0, 0, 40, 30)];
    
    return [[UIBarButtonItem alloc]
            initWithCustomView:barButton];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    if ([_parentController respondsToSelector:@selector(rightSideMenuButtonPressed:)]) {
        [barButton addTarget:_parentController action:@selector(rightSideMenuButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    } else NSLog(@"ERROR %@ did not respond to selector:(%@)", NSStringFromClass([_parentController class]), @"rightSideMenuButtonPressed:");
    [barButton setFrame:CGRectMake(0, 0, 40, 30)];
    
    return [[UIBarButtonItem alloc]
            initWithCustomView:barButton];
}

- (UIBarButtonItem *)backBarButtonItem {
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [barButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    if ([_parentController respondsToSelector:@selector(backButtonPressed:)]) {
        [barButton addTarget:_parentController action:@selector(backButtonPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    } else NSLog(@"ERROR %@ did not respond to selector:(%@)", NSStringFromClass([_parentController class]), @"backButtonPressed:");
    [barButton setFrame:CGRectMake(0, 0, 40, 30)];
    
    return [[UIBarButtonItem alloc]
            initWithCustomView:barButton];
   
}

@end
