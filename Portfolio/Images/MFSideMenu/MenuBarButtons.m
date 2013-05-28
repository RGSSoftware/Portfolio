//
//  MenuBarButtons.m
//  MFSideMenuDemoBasic
//
//  Created by PC on 5/27/13.
//  Copyright (c) 2013 University of Wisconsin - Madison. All rights reserved.
//

#import "MenuBarButtons.h"

#import "MFSideMenuContainerViewController.h"


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
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:_parentController
            action:@selector(leftSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:_parentController
            action:@selector(rightSideMenuButtonPressed:)];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:_parentController
                                           action:@selector(backButtonPressed:)];
}


@end
