//
//  RGSVideo2ViewController.m
//  Portfolio
//
//  Created by PC on 6/11/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSVideo2ViewController.h"

#import <Parse/Parse.h>
#import <RestKit/RestKit.h>

#import "Video.h"

#import "AsyncImageView.h"

#import "RGSVideoCell.h"

#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"

NSString *const kAPIKEY = @"AIzaSyD1zIG_HErAICBi355-nPLzaxdAY71egIQ";
NSString *const APIManagerBaseURL = @"https://www.googleapis.com/youtube";

NSString *const localbaseURL = @"http://localhost:8888/google_youtybeData.json";

//#define MYDEBUGNETWORK


@interface RGSVideo2ViewController ()
@property(nonatomic,strong)NSMutableArray *videos;

@end

@implementation RGSVideo2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    [dateFormat setDateFormat:@"HH:mm:ss.s"];
    NSString *timeString = [dateFormat stringFromDate:date];
    
    NSString *youtubeDateFormate = [NSString stringWithFormat:@"%@T%@Z", dateString, timeString];
    // convert it to a string
        
    //NSLog(DATE);
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    
    self.tableView.backgroundView = texturedBackgroundView;
    //self.tableView.backgroundView.backgroundColor = [UIColor brownColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [[self tableView] registerClass:[RGSVideoCell class] forCellReuseIdentifier:@"Cell"];
	
    _videos = [NSMutableArray new];
    
    RKObjectManager *youtubeAPImanager = [self youtubeAPIManager];
    RKObjectMapping *youtubeMapping = [self youtubeMapping];
    
    RKResponseDescriptor *responseDescriptior = [RKResponseDescriptor responseDescriptorWithMapping:youtubeMapping
                                                                                      pathPattern:nil
                                                                                          keyPath:@"items"
                                                                                      statusCodes:nil];
    
    
#ifdef MYDEBUGNETWORK
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:localbaseURL]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptior]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"video count: %d", [[result array] count]);
        for (Video *video in [result array]) {
            NSLog(@"%@ -----ID:%@", video.title,video.ID);
        }
        NSLog(@"local test data: %@", [result array]);
        
    } failure:nil];
    [operation start];
    
#else
    [youtubeAPImanager addResponseDescriptor:responseDescriptior];
    
 //   [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptior];
    NSDictionary *queryParams = [NSDictionary new];
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:@"snippet", @"part",_channelID, @"channelId",  kAPIKEY, @"key", nil];
       
    /*[objectManager getObjectsPath] <------ this was the problem */
    [youtubeAPImanager getObjectsAtPath:@"v3/search" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                _videos = [NSMutableArray arrayWithArray:[mappingResult array]];
                                
                                [self.tableView reloadData];
                                
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    
   
#endif /* MYDEBUGNETWORK */
}

-(RKObjectManager *)youtubeAPIManager
{
#ifdef MYDEBUGNETWORK
    NSURL *baseURL = [NSURL URLWithString:localbaseURL];
#else
    NSURL *baseURL = [NSURL URLWithString:APIManagerBaseURL];
#endif /* DEBUGNETWORK */
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    return objectManager;
}

-(RKObjectMapping *)youtubeMapping
{
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[Video class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
        @"id.videoId" : @"ID",
        @"snippet.title": @"title",
        @"snippet.descriptionl": @"description"
     }];
   
    
       
    RKObjectMapping *thumbnailMapping = [RKObjectMapping requestMapping];
    [thumbnailMapping addAttributeMappingsFromDictionary:@{
        @"default": @"low",
        @"medium": @"medium",
        @"high": @"high"
     }];
    RKRelationshipMapping *thumbnailRelation = [RKRelationshipMapping relationshipMappingFromKeyPath:@"snippet.thumbnails"
                                                                                           toKeyPath:@"thumbnails"
                                                                                         withMapping:thumbnailMapping];
    [videoMapping addPropertyMapping:thumbnailRelation];
    
        
    return videoMapping;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_videos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [[RGSVideoCell new] videoCellHeight] + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    RGSVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RGSVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Video *video = [_videos objectAtIndex:indexPath.row];
    cell.tumbnailView.image = [UIImage imageNamed:@"photo3.jpg"];
    
    [cell.videoTitle setText:video.title];
                                
    cell.tumbnailView.imageURL = [NSURL URLWithString:[[video.thumbnails objectForKey:@"high"] objectForKey:@"url"]];
                                
                                
                           
    
    return cell;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
