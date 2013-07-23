//
//  RGSVideo2ViewController.m
//  Portfolio
//
//  Created by PC on 6/11/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSVideoViewController.h"

#import "RGSAppDelegate.h"

#import <Parse/Parse.h>
#import <RestKit/RestKit.h>

#import "Video.h"

#import "AsyncImageView.h"
#import "XCDYouTubeVideoPlayerViewController.h"

#import "RGSVideoCell.h"

#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"

NSString *const kAPIKEY = @"AIzaSyD1zIG_HErAICBi355-nPLzaxdAY71egIQ";
NSString *const APIManagerBaseURL = @"https://www.googleapis.com/youtube";

NSString *const localbaseURL = @"http://localhost:8888/google_youtybeData.json";

NSInteger const rowHeightPadding = 10;
NSString *const videoCellIdentifier = @"Cell";
NSString *const videoCellTumbnailPlaceholder = @"photo3.jpg";

typedef enum{
    videoTypeNew,
    videoTypeOld
}videoType;

//#define MYDEBUGNETWORK


@interface RGSVideoViewController ()
@property(nonatomic,strong)NSMutableArray *videos;

@property(nonatomic,strong)NSDate *dateQuery;

@property(nonatomic)CGFloat rowHeight;

@end

@implementation RGSVideoViewController

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
    
    //NSLog(DATE);
    _videos = [NSMutableArray new];
    for (int i = 0; i < 2; i++) {
        [_videos addObject:[NSMutableArray array]];
    }
    RGSAppDelegate* ad = (RGSAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = ad.managedObjectContext;
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    
    self.tableView.backgroundView = texturedBackgroundView;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = [[RGSVideoCell new] videoCellHeight] + rowHeightPadding;
    
    [[self tableView] registerClass:[RGSVideoCell class] forCellReuseIdentifier:videoCellIdentifier];
    
    RKObjectManager *youtubeAPImanager = [self youtubeAPIManager];
    RKObjectMapping *youtubeMapping = [self youtubeMapping];
    
    RKResponseDescriptor *responseDescriptior = [RKResponseDescriptor responseDescriptorWithMapping:youtubeMapping
                                                                                        pathPattern:nil
                                                                                            keyPath:@"items"
                                                                                        statusCodes:nil];
    [youtubeAPImanager addResponseDescriptor:responseDescriptior];
	
    NSError *error;
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    NSEntityDescription *lastDateCheckEntity = [NSEntityDescription entityForName:@"LastDateCheck" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:lastDateCheckEntity];
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    /* check to see if coreDate is holding last saved date */
    if ([fetchedObjects count] == 0) {
        
        /*there's no saved date in coredata*/
        
        NSDate *date = [NSDate date];
    
        NSManagedObject *currentDate = [NSEntityDescription insertNewObjectForEntityForName:@"LastDateCheck" inManagedObjectContext:_managedObjectContext];
        [currentDate setValue:date forKey:@"date"];
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
    NSDictionary *youtubeQuery = [self youtubeQuerywithDate:date setBefore:YES];

    [youtubeAPImanager getObjectsAtPath:@"v3/search" parameters:youtubeQuery
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    if ([[mappingResult array] count] == 0) {
                                
                                    } else {
                                        NSMutableArray *oldVideos = [NSMutableArray arrayWithArray:[mappingResult array]];
                                        [[_videos objectAtIndex:videoTypeOld] setArray:oldVideos];
                                
                                        [self.tableView reloadData];
                                    }
                                }
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error: %@", [error localizedDescription]);
                                }];
    } else {
        /*There's saved data.*/
        
        NSDate *lastCheckDate;
        NSManagedObject *dateObject;
        for (NSManagedObject *lastDate in fetchedObjects) {
            lastCheckDate = [lastDate valueForKey:@"date"];
            dateObject = lastDate;
        }
        
        NSDictionary *youtubeQuery = [self youtubeQuerywithDate:lastCheckDate setBefore:NO];
        [youtubeAPImanager getObjectsAtPath:@"v3/search" parameters:youtubeQuery
                                    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        if ([[mappingResult array] count] == 0) {
                                        
                                        } else {
                                            NSMutableArray *newVideos = [NSMutableArray arrayWithArray:[mappingResult array]];
                                            [[_videos objectAtIndex:videoTypeNew] setArray:newVideos];
                                        
                                            [self.tableView reloadData];
                                        }
                                        
                                    }
                                    failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error: %@", [error localizedDescription]);
                                    }];
        
        youtubeQuery = [self youtubeQuerywithDate:lastCheckDate setBefore:YES];
        [youtubeAPImanager getObjectsAtPath:@"v3/search" parameters:youtubeQuery
                                    success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                        if ([[mappingResult array] count] == 0) {
                                            
                                        } else {
                                            NSMutableArray *oldVideos = [NSMutableArray arrayWithArray:[mappingResult array]];
                                            [[_videos objectAtIndex:videoTypeOld] setArray:oldVideos];
                                            
                                            [self.tableView reloadData];
                                        }
                                    }
                                    failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                        NSLog(@"Error: %@", [error localizedDescription]);
                                    }];
        
        [dateObject setValue:[NSDate date] forKey:@"date"];
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

-(NSDictionary *)youtubeQuerywithDate:(NSDate *)date setBefore:(BOOL)setBefore
{
    NSString *dateFormate = [self dateToYoutubeFormate:date];
    
    NSDictionary *queryParams = [NSDictionary new];
    if (setBefore) {
        queryParams = [NSDictionary dictionaryWithObjectsAndKeys:@"snippet", @"part",
                                 _channelID, @"channelId",
                                 dateFormate, @"publishedBefore",
                                 kAPIKEY, @"key",
                                 nil];
        
        return queryParams;
    } else {
        queryParams = [NSDictionary dictionaryWithObjectsAndKeys:@"snippet", @"part",
                       _channelID, @"channelId",
                       dateFormate, @"publishedAfter",
                       kAPIKEY, @"key",
                       nil];
    }
    
    return queryParams;
}

-(NSString *)dateToYoutubeFormate:(NSDate *)date
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    
    [dateFormat setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    
    [dateFormat setDateFormat:@"HH:mm:ss.s"];
    NSString *timeString = [dateFormat stringFromDate:date];
    
    NSString *youtubeDateFormate = [NSString stringWithFormat:@"%@T%@Z", dateString, timeString];
    
    return youtubeDateFormate;
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
        @"snippet.description": @"description"
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
    return [_videos count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_videos objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RGSVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (cell == nil) {
        cell = [[RGSVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellIdentifier];
        
    }
    
    Video *video = [[_videos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.tumbnailView.image = [UIImage imageNamed:videoCellTumbnailPlaceholder];
    
    [cell.videoTitle setText:video.title];
                                
    cell.tumbnailView.imageURL = [NSURL URLWithString:[[video.thumbnails objectForKey:@"high"] objectForKey:@"url"]];
                                
    return cell;
}

-(void)videoCell:(RGSVideoCell *)videoCell didTapPlayButton:(UIButton *)button
{
    NSIndexPath *videoCellIndex = [self.tableView indexPathForCell:videoCell];
    
    Video *videoData = [[_videos objectAtIndex:videoCellIndex.section] objectAtIndex:videoCellIndex.row];
    
    XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoData.ID];
    videoPlayerViewController.preferredVideoQualities = @[[NSNumber numberWithInteger:XCDYouTubeVideoQualityMedium360]];
    [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
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
