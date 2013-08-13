//
//  SideMenuViewController.m
//  MFSideMenuDemo
//
//  Created by Michael Frederick on 3/19/12.



#import "SideMenuViewController.h"
#import "SidebarCell.h"

#import <Parse/Parse.h>
#import "ConfigManager.h"


#import "GalleryViewControllerContainer.h"
#import "VideoViewControllerContainer.h"
#import "ContactViewController.h"
#import "AboutMeViewController.h"
#import "InfoViewController.h"

#import "MFSideMenu.h"
#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"

#import "DEBUGHeader.h"

int const buttonCellHeight = 80;

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
    
    _viewControllers = [NSMutableArray array];
    
    
    [_viewControllers addObject:[VideoViewControllerContainer new]];
    [_viewControllers addObject:[GalleryViewControllerContainer new]];
    [_viewControllers addObject:[AboutMeViewController new]];
    [_viewControllers addObject:[ContactViewController new]];
    [_viewControllers addObject:[InfoViewController new]];
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    
    self.tableView.backgroundView = texturedBackgroundView;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.scrollEnabled = NO;
    self.clearsSelectionOnViewWillAppear = NO;
    


    _iconButtons = [[[ConfigManager sharedManager] sideMenuConfig ] objectForKey:@"Icons"];

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
    
    SidebarCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SidebarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:244/255.0 green:76/255.0 blue:76/255.0 alpha:1];
        cell.selectedBackgroundView = selectionColor;
        
    }
    if (!_iconButtons) {
        return cell;
    } else {

#ifdef MYDEBUG
        
        cell.icon.image = [_iconButtons[indexPath.row] objectForKey:@"iconImage"];
        cell.description.text = [_iconButtons[indexPath.row] objectForKey:@"description"];
        
        return cell;
        
#else
        cell.icon.image = [UIImage imageWithData:[_iconButtons[indexPath.row] objectForKey:@"iconData"]];
        cell.description.text = [_iconButtons[indexPath.row] objectForKey:@"description"];
    
        return cell;
        
#endif /* MYDEBUG */
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *viewcontroller = [_viewControllers objectAtIndex:indexPath.row];

    UINavigationController *centerNavigationController = self.menuContainerViewController.centerViewController;

    if ([centerNavigationController.topViewController isKindOfClass:[viewcontroller class]]) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else {

        centerNavigationController.viewControllers = @[viewcontroller];
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return buttonCellHeight;
}

-(void)changeCa:(UIViewController *)gallerycontroller
{
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    navigationController.viewControllers = @[gallerycontroller];
}



@end
