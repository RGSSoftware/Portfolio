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
    @property NSMutableArray *videosMetaData;
    @property BOOL metaDataLoaded;
   // @property NSInteger *videoCategoryIndex;
    @property NSDictionary *config;


@end

@implementation videoViewController
    @synthesize videosMetaData = _videosMetaData;
    @synthesize metaDataLoaded = _metaDataLoaded;
   // @synthesize videoCategoryIndex = _videoCategoryIndex;
    @synthesize config = _config;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //_metaDataLoaded = NO;
       // _videosMetaData = [NSMutableArray new];
        //_videoCategories = [NSMutableArray new];
       
        /*
        NSMutableArray *musicVideos = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            [musicVideos addObject:[NSString stringWithFormat:@"V5MWyVAUbI0"]];
        }
        [_videoCategories addObject:musicVideos];
        
        NSMutableArray *ComedySkits = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            [ComedySkits addObject:[NSString stringWithFormat:@"V5MWyVAUbI0"]];
        }
        [_videoCategories addObject:ComedySkits];
        
        NSMutableArray *vLogs = [NSMutableArray new];
        for (int i = 0; i < 10; i++) {
            [vLogs addObject:[NSString stringWithFormat:@"V5MWyVAUbI0"]];
        }
        [_videoCategories addObject:vLogs];
         
        
        NSString *configFilePath = [[NSBundle mainBundle] pathForResource:@"youtubeConfig" ofType:@"plist"];
    _config = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
    _videoCategories = [_config objectForKey:@"videosCategories"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"configFinishedLoading" object:nil];
        */
        
        
    //j,_videoCategories = [_config objectForKey:@"videosCategories"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _videosMetaData = [NSMutableArray new];
    _videoCategories = [NSMutableArray new];
    _metaDataLoaded = NO;
    
    ConfigManager *conn = [ConfigManager sharedManager];
    _videoCategories = [[[ConfigManager sharedManager] shortFilmsConfig] objectForKey:@"videosCategories"];
                                                      
    NSInteger i = _segmentedControl.selectedSegmentIndex;
    NSArray *videoCategory = [_videoCategories objectAtIndex:i];
    
    RKObjectManager *youtubeAPImanager = [self youtubeAPIManager];
    RKObjectMapping *youtubeMapping = [self youtubeMapping];
    
    RKResponseDescriptor *responeDecriptior = [RKResponseDescriptor responseDescriptorWithMapping:youtubeMapping
                                                                                      pathPattern:nil
                                                                                          keyPath:@"items"
                                                                                      statusCodes:nil];
    [youtubeAPImanager addResponseDescriptor:responeDecriptior];
    
    [self downloadVideosMetaData:videoCategory];

    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"videoMetaDataFinishedLoading"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      _metaDataLoaded = YES;
                                                      [self.tableView reloadData];
                                                  }];
    
    
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

-(void)downloadVideosMetaData:(NSArray *)videos
{
    //NSArray *videos = [_config objectForKey:@"videos"];
    
    NSMutableString *videoParam = [NSMutableString new];
    for (NSString *videoid in videos) {
        [videoParam appendString:[NSString stringWithFormat:@"%@,", videoid]];
    }
    
    NSString *apiKey = [NSString stringWithUTF8String:kAPIKEY];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:videoParam, @"id", @"snippet,player", @"part", apiKey, @"key", nil];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:@"v3/videos" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSLog(@"objects[%d]", [[mappingResult array] count]);
                                [_videosMetaData addObject:[mappingResult array]];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"videoMetaDataFinishedLoading" object:nil];
                                
                                
                                //video *v = (video *)_videos[0];
                                //NSLog(@"video id:%@ thumbnail-url:%@", v.ID, [[v.snippet.thumbnails[0] objectForKey:@"high"] objectForKey:@"url"]);
                                //NSLog(@"video player url:%@", v.player.embedHtml);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    
}




-(void)changeCategory
{
    if ([_videosMetaData count] == 3) {
        [self.tableView reloadData];
        return;
    }
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
    
    NSInteger videoCategory = _segmentedControl.selectedSegmentIndex;
    
   return [[_videoCategories objectAtIndex:videoCategory] count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    photoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[photoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"photo3.jpg"];
    
    NSInteger videoCategoryIndex = _segmentedControl.selectedSegmentIndex;
    NSString *videoID = [[_videoCategories objectAtIndex:videoCategoryIndex] objectAtIndex:indexPath.row];
    
    NSString *apiKey = [NSString stringWithUTF8String:kAPIKEY];
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:videoID, @"id", @"snippet,player", @"part", apiKey, @"key", nil];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:@"v3/videos" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSLog(@"objects[%d]", [[mappingResult array] count]);
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

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
