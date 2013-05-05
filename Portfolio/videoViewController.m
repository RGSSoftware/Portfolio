//
//  videoViewController.m
//  Portfolio
//
//  Created by PC on 4/22/13.
//  Copyright (c) 2013 PC. All rights reserved.
//


#import <Parse/Parse.h>
#import <RestKit/RestKit.h>

#import "video.h"
#import "snippet.h"
#import "player.h"

#import "SDSegmentedControl.h"
#import "AsyncImageView.h"

#import "MFSideMenuController.h"
#import "MFSideMenu.h"
#import "ConfigManager.h"

#import "photoCell.h"
#import "videoViewController.h"

@interface videoViewController ()
    


@end

@implementation videoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _videoCategories = [NSMutableArray new];
    
   
    _videoCategories = [[[ConfigManager sharedManager] shortFilmsConfig] objectForKey:@"videosCategories"];
    
    RKObjectManager *youtubeAPImanager = [self youtubeAPIManager];
    RKObjectMapping *youtubeMapping = [self youtubeMapping];
    
    RKResponseDescriptor *responeDecriptior = [RKResponseDescriptor responseDescriptorWithMapping:youtubeMapping
                                                                                      pathPattern:nil
                                                                                          keyPath:@"items"
                                                                                      statusCodes:nil];
    [youtubeAPImanager addResponseDescriptor:responeDecriptior];
    
    
    
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wide_rectangles.png"]];
    
    self.tableView.backgroundView = texturedBackgroundView;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [[self tableView] registerClass:[photoCell class] forCellReuseIdentifier:@"Cell"];
    
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Music Videos", @"Comedy Skits", @"Vlogs", nil];
    _segmentedControl = [[SDSegmentedControl alloc] initWithItems:itemArray];
    [_segmentedControl addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.title = @"Short Films";
    /*
     MFSideMenuController *sideMenu = [MFSideMenuController new];
     */
    [self setupMenuBarButtonItems];

    
}
-(RKObjectManager *)youtubeAPIManager
{
    NSURL *baseURL = [NSURL URLWithString:@"https://www.googleapis.com/youtube"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    return objectManager;
}

-(RKObjectMapping *)youtubeMapping
{
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[video class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"ID"
     }];
    
    RKObjectMapping *snippetMapping = [RKObjectMapping mappingForClass:[snippet class]];
    [snippetMapping addAttributeMappingsFromDictionary:@{@"title": @"title", @"description": @"description"}];
    RKRelationshipMapping *snippetRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"snippet"
                                                                                         toKeyPath:@"snippet"
                                                                                       withMapping:snippetMapping];
    [videoMapping addPropertyMapping:snippetRelation];
    
    RKObjectMapping *thumbnailMapping = [RKObjectMapping requestMapping];
    [thumbnailMapping addAttributeMappingsFromArray:@[@"default", @"medium", @"high"]];
    RKRelationshipMapping *thumbnailRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"thumbnails"
                                                                                           toKeyPath:@"thumbnails"
                                                                                         withMapping:thumbnailMapping];
    [snippetMapping addPropertyMapping:thumbnailRelation];
    
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[player class]];
    //[playerMapping addAttributeMappingsFromArray:@[@"embedHtml"]];
    [playerMapping addAttributeMappingsFromDictionary:@{@"embedHtml": @"embedHtml"}];
    RKRelationshipMapping *playerRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"player"
                                                                                        toKeyPath:@"player"
                                                                                      withMapping:playerMapping];
    [videoMapping addPropertyMapping:playerRelation];
    
    return videoMapping;
}

-(void)changeCategory
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setupMenuBarButtonItems {
    switch (self.navigationController.sideMenu.menuState) {
        case MFSideMenuStateClosed:
            if([[self.navigationController.viewControllers objectAtIndex:0] isEqual:self]) {
                self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            } else {
                self.navigationItem.leftBarButtonItem = [self backBarButtonItem];
            }
            //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
        case MFSideMenuStateLeftMenuOpen:
            self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
            break;
        case MFSideMenuStateRightMenuOpen:
            //self.navigationItem.rightBarButtonItem = [self rightMenuBarButtonItem];
            break;
    }
}

- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self.navigationController.sideMenu
            action:@selector(toggleLeftSideMenu)];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-arrow"]
                                            style:UIBarButtonItemStyleBordered
                                           target:self
                                           action:@selector(backButtonPressed:)];
}

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger sectionIndex = _segmentedControl.selectedSegmentIndex;
    
   return [[_videoCategories objectAtIndex:sectionIndex] count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    photoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[photoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"photo3.jpg"];
    
    NSInteger sectionIndex = _segmentedControl.selectedSegmentIndex;
    NSString *videoID = [[_videoCategories objectAtIndex:sectionIndex] objectAtIndex:indexPath.row];
    
    NSString *apiKey = [NSString stringWithUTF8String:kAPIKEY];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:videoID, @"id", @"snippet,player", @"part", apiKey, @"key", nil];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:@"v3/videos" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
                                video *v = (video *)[mappingResult array][0];
                                
                                [cell.userButton setText:v.snippet.title];
                                cell.imageView.imageURL = [NSURL URLWithString:[[v.snippet.thumbnails[0] objectForKey:@"medium"] objectForKey:@"url"]];

                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];

    return cell;
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 270.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return _segmentedControl;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
