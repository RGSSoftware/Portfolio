//
//  videoViewController.m
//  Portfolio
//
//  Created by PC on 4/22/13.
//  Copyright (c) 2013 PC. All rights reserved.
//


#import <Parse/Parse.h>
#import <RestKit/RestKit.h>


#import "Video.h"


#import "SDSegmentedControl.h"
#import "AsyncImageView.h"


#import "ConfigManager.h"

#import "RGSVideoCell.h"
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
    
    [[self tableView] registerClass:[RGSVideoCell class] forCellReuseIdentifier:@"Cell"];
    
    
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Music Videos", @"Comedy Skits", @"Vlogs", nil];
    _segmentedControl = [[SDSegmentedControl alloc] initWithItems:itemArray];
    _segmentedControl.arrowHeightFactor = 0;
    _segmentedControl.interItemSpace = 5;
    [_segmentedControl addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.title = @"Short Films";
    /*
     MFSideMenuController *sideMenu = [MFSideMenuController new];
     */
  

    
}
-(RKObjectManager *)youtubeAPIManager
{
    NSURL *baseURL = [NSURL URLWithString:@"https://www.googleapis.com/youtube"];
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    return objectManager;
}

-(RKObjectMapping *)youtubeMapping
{
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[Video class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"ID"
     }];
    
    RKObjectMapping *snippetMapping = [RKObjectMapping mappingForClass:[Snippet class]];
    [snippetMapping addAttributeMappingsFromDictionary:@{@"title": @"title", @"description": @"description"}];
    RKRelationshipMapping *snippetRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"snippet"
                                                                                         toKeyPath:@"snippet"
                                                                                       withMapping:snippetMapping];
    [videoMapping addPropertyMapping:snippetRelation];
    
    RKObjectMapping *thumbnailMapping = [RKObjectMapping requestMapping];
    [thumbnailMapping addAttributeMappingsFromArray:@[@"default", @"medium", @"high"]];
    RKRelationshipMapping *thumbnailRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"snippet.thumbnails"
                                                                                           toKeyPath:@"thumbnails"
                                                                                         withMapping:thumbnailMapping];
    [videoMapping addPropertyMapping:thumbnailRelation];
    
    RKObjectMapping *playerMapping = [RKObjectMapping mappingForClass:[Player class]];
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
    
    
    
    RGSVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RGSVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.tumbnailView.image = [UIImage imageNamed:@"photo3.jpg"];
    
    NSInteger sectionIndex = _segmentedControl.selectedSegmentIndex;
    NSString *videoID = [[_videoCategories objectAtIndex:sectionIndex] objectAtIndex:indexPath.row];
    
    NSString *apiKey = [NSString stringWithUTF8String:kAPIKEY];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:videoID, @"id", @"snippet,player", @"part", apiKey, @"key", nil];
    
    
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSLog(@"sharedManger resonseDecriptior%@", objectManager.responseDescriptors[0]);
    [objectManager getObjectsAtPath:@"v3/videos" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
                                Video *v = (Video *)[mappingResult array][0];
                                
                                
                                
                                [cell.videoTitle setText:v.snippet.title];
                               
                                cell.tumbnailView.imageURL = [NSURL URLWithString:[[v.thumbnails objectForKey:@"high"] objectForKey:@"url"]];
                               // cell.tumbnailView.imageURL = [NSURL URLWithString:[[[v.snippet.thumbnails objectForKey:@"high"] objectForKey:@"url"]];

                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];

    return cell;
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[RGSVideoCell new] videoCellHeight] + 10;
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
