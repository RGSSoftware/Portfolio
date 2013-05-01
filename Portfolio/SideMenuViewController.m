//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.

#import "MFSideMenu.h"

#import "SideMenuViewController.h"

//#import "youtubeViewController.h"
#import "galleryViewController.h"
//#import "tableViewController.h"
#import "videoViewController.h"

//#import "sidebarCell.h"

@implementation SideMenuViewController

@synthesize sideMenu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _viewControllers = [NSMutableArray array];
    [_viewControllers addObject:[galleryViewController new]];
    [_viewControllers addObject:[videoViewController new]];
    //[_viewControllers addObject:[tableViewController new]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"debut_dark.png"]];
    
    self.tableView.backgroundView = texturedBackgroundView;
    //self.tableView.backgroundView.backgroundColor = [UIColor brownColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
}


#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_viewControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 45)];
    icon.image = [UIImage imageNamed:@"stack_of_photos-512copy.png"];
        
    [cell.contentView addSubview:icon];
   
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewcontroller = [_viewControllers objectAtIndex:indexPath.row];

    if ([self.sideMenu.navigationController.topViewController isKindOfClass:[viewcontroller class]]) {
        [self.sideMenu.navigationController popToRootViewControllerAnimated:YES];
        [self.sideMenu setMenuState:MFSideMenuStateClosed];
    } else {
         NSArray *controllers = [NSArray arrayWithObject:viewcontroller];
    self.sideMenu.navigationController.viewControllers = controllers;
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

@end
