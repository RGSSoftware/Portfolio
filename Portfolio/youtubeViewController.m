//
//  FirstViewController.m
//  youtube
//
//  Created by PC on 2/21/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "youtubeViewController.h"
#import <RestKit/RestKit.h>
#import <Parse/Parse.h>
#import "SDSegmentedControl.h"
#import "photoCell.h"

#import "MFSideMenuController.h"
#import "MFSideMenu.h"

#import "video.h"
#import "snippet.h"
#import "player.h"


@interface youtubeViewController ()
    @property NSArray *videos;
    @property NSDictionary *config;

@end

@implementation youtubeViewController
    @synthesize videos = _videos;
    @synthesize config = _config;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        _videoCategories = [NSMutableArray new];
        
        NSMutableArray *musicVideos = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            [musicVideos addObject:[NSString new]];
        }
        [_videoCategories addObject:musicVideos];
        
        NSMutableArray *ComedySkits = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            [ComedySkits addObject:[NSString new]];
        }
        [_videoCategories addObject:ComedySkits];
        
        NSMutableArray *vLogs = [NSMutableArray new];
        for (int i = 0; i < 10; i++) {
            [vLogs addObject:[NSString new]];
        }
        [_videoCategories addObject:vLogs];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self downloadConfig];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"configFinishedLoading"
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      RKObjectManager *youtubeAPImanager = [self youtubeAPIManager];
                                                      RKObjectMapping *youtubeMapping = [self youtubeMapping];
    
                                                      RKResponseDescriptor *responeDecriptior = [RKResponseDescriptor responseDescriptorWithMapping:youtubeMapping
                                                                                      pathPattern:nil
                                                                                          keyPath:@"items"
                                                                                                        statusCodes:nil];
                                                      [youtubeAPImanager addResponseDescriptor:responeDecriptior];
    
                                                      [self sendReqest];
                                                  }];
    
    NSArray *urls = [NSArray arrayWithObjects:@"bxiNJQhutDo",@"BG4LE8sPpxE", @"q86-_hMsSf4", @"9xNdDNoOfXE", @"kz8EPqweqA4", @"CiM4N4CXWXE", nil];
    NSArray *videoOntlets = [NSArray arrayWithObjects:_video1, _video2, _video3, _video4, _video5, _video6, nil];
    
    for (NSInteger i = 0; i < ([urls count]) ; i++) {
        NSString *videourl = [NSString stringWithFormat:@"http://www.youtube.com/embed/%@?controls=0&modestbranding=1&rel=0&showinfo=0&theme=light",[urls objectAtIndex:i]];
        //[self embedYouTube:videourl view:[videoOntlets objectAtIndex:i]];

    }
    
   
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundLeather.png"]];
    
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

-(void)sendReqest
{
    NSArray *videos = [_config objectForKey:@"videos"];
    
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
                                _videos = [mappingResult array];
                                //video *v = (video *)_videos[0];
                                //NSLog(@"video id:%@ thumbnail-url:%@", v.ID, [[v.snippet.thumbnails[0] objectForKey:@"high"] objectForKey:@"url"]);
                                //NSLog(@"video player url:%@", v.player.embedHtml);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];

}

-(void)downloadConfig
{
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"youtube"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSLog(@"Succesfully retrieved config.");
            
            PFObject *object = objects[0];
            PFFile *file = [object objectForKey:@"file"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    _config = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"configFinishedLoading" object:nil];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)embedYouTube:(NSString *)urlString view:(UIWebView *)view {
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <iframe type='text/html' src='%@\' width='120' height='100' frameborder='0' controls='0' allowfullscreen='true'/>\
    </body></html>";
    
   
    
   NSString *html = [NSString stringWithFormat:embedHTML, urlString];
    [view loadHTMLString:html baseURL:nil];
   
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger videoCategory = _segmentedControl.selectedSegmentIndex;
    
    NSLog(@"selectedIndex: %d", videoCategory);
    return [[_videoCategories objectAtIndex:videoCategory] count];
    NSLog(@"_videoCategories count:%d", [_videoCategories count]);
    //return 10;
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    photoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:@"photo3.jpg"];
    //cell.imageView.image = [UIImage imageNamed:@"playButton.png"];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 270.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //Create the segmented control
	
	//segmentedControl.frame = CGRectMake(35, 200, 250, 70);
	//segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
	//segmentedControl.selectedSegmentIndex = 1;
	//[segmentedControl addTarget:self action:@selector(pickOne:) forControlEvents:UIControlEventValueChanged];
	return _segmentedControl;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}
-(void)changeCategory
{
    [self.tableView reloadData];
}

/*
- (UIBarButtonItem *)rightMenuBarButtonItem {
    return [[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStyleBordered
            target:self.navigationController.sideMenu
            action:@selector(toggleRightSideMenu)];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
