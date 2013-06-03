//
//  SideMenuViewController.h
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"
#import "GalleryViewControllerManger.h"
#import "DEBUGHeader.h"

@interface SideMenuViewController : UITableViewController<UISearchBarDelegate>
{

}

- (MFSideMenuContainerViewController *)menuContainerViewController;
-(void)changeCa:(UIViewController *)gallerycontroller;

@end