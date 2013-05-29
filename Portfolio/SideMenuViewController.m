//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.



#import "SideMenuViewController.h"
#import "sidebarCell.h"

#import <Parse/Parse.h>
#import "GalleryViewControllerManger.h"

#import "GalleryViewController.h"
#import "videoViewController.h"
#import "ContactViewController.h"
#import "aboutMeViewController.h"

#import "MFSideMenu.h"
#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"

@interface SideMenuViewController()
@property NSMutableArray *viewControllers;
@property NSMutableArray *iconButtons;
@property NSArray *desciptions;

@end
@implementation SideMenuViewController

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
    
    GalleryViewControllerManger *galleryManager = [GalleryViewControllerManger sharedManager];
    _viewControllers = [NSMutableArray array];
    
    
    [_viewControllers addObject:[videoViewController new]];
    [_viewControllers addObject:[galleryManager galleryViewController:GalleryCategorySignature]];
    [_viewControllers addObject:[aboutMeViewController new]];
    [_viewControllers addObject:[ContactViewController new]];
    [_viewControllers addObject:[videoViewController new]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    
    self.tableView.backgroundView = texturedBackgroundView;
    //self.tableView.backgroundView.backgroundColor = [UIColor brownColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
   
    if (!_iconButtons) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray *downloadIcons = [self downloadIcons];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                _iconButtons = [NSMutableArray arrayWithArray:downloadIcons];
                
                [self.tableView reloadData];
                
            });
        });
    }
    
}

-(NSArray *)downloadIcons
{
    PFQuery *query = [PFQuery queryWithClassName:@"SideBarButtons"];
    [query orderByAscending:@"order_number"];
    NSArray *objects = [query findObjects];
    
    NSLog(@"Successfully retrieved %d icon objects.", objects.count);
    
    NSMutableArray *icons = [NSMutableArray new];
    for (PFObject *eachobject in objects) {
        NSMutableDictionary *buttons = [NSMutableDictionary new];
        [icons addObject:buttons];
        
        PFFile *iconFile = [eachobject objectForKey:@"icon"];
        NSData *iconData = [iconFile getData];
        [buttons setObject:iconData forKey:@"iconData"];
        
        NSString *description = [eachobject objectForKey:@"description"];
        [buttons setObject:description forKey:@"description"];
        
    }
    
    return icons;
}
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.parentViewController;
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
    
    sidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[sidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (!_iconButtons) {
        return cell;
    } else {

        cell.icon.image = [UIImage imageWithData:[_iconButtons[indexPath.row] objectForKey:@"iconData"]];
        cell.description.text = [_iconButtons[indexPath.row] objectForKey:@"description"];
    
        return cell;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewcontroller = [_viewControllers objectAtIndex:indexPath.row];

    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;

    if ([navigationController.topViewController isKindOfClass:[viewcontroller class]]) {
        [navigationController popToRootViewControllerAnimated:YES];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {
        navigationController.viewControllers = @[viewcontroller];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

@end
