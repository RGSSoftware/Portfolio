//
//  RGSVideo2ViewController.m
//  Portfolio
//
//  Created by PC on 6/11/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "VideoViewController.h"

#import "RGSAppDelegate.h"

#import <Parse/Parse.h>
#import <RestKit/RestKit.h>
#import "MBProgressHUD.h"

#import "Video.h"

#import "AsyncImageView.h"
#import "CustomYouTubeVideoPlayerViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"

#import "VideoCell.h"

#import "MenuBarButtons.h"
#import "MFSideMenu/MFSideMenu.h"

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


@interface VideoViewController ()
@property(nonatomic,strong)NSMutableArray *videos;

@property(nonatomic,strong)NSDate *dateQuery;

@property(nonatomic)CGFloat rowHeight;

@end

@implementation VideoViewController

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
    
    _videos = [NSMutableArray new];
    for (int i = 0; i < 2; i++) {
        [_videos addObject:[NSMutableArray array]];
    }
    
    
    RGSAppDelegate* ad = (RGSAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = ad.managedObjectContext;
    
    UIView *texturedBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    texturedBackgroundView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundView = texturedBackgroundView;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = [[VideoCell new] videoCellHeight] + rowHeightPadding;
    
    [[self tableView] registerClass:[VideoCell class] forCellReuseIdentifier:videoCellIdentifier];
    
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
        
        NSDate *currentDate = [NSDate date];
    
        NSManagedObject *managedObjectDate = [NSEntityDescription insertNewObjectForEntityForName:@"LastDateCheck" inManagedObjectContext:_managedObjectContext];
        [managedObjectDate setValue:currentDate forKey:@"date"];
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
        
        NSDictionary *youtubeQuery = [NSDictionary dictionary];
        
        youtubeQuery = [self youtubeQuerywithDate:currentDate setBefore:YES];
        [self downloadVideosWithAPImanager:youtubeAPImanager
                                     query:youtubeQuery
                                 NewVideos:NO];

    } else {
        /*There's saved data.*/
        
        NSDate *lastCheckDate;
        NSManagedObject *dateObject;
        for (NSManagedObject *lastDate in fetchedObjects) {
            lastCheckDate = [lastDate valueForKey:@"date"];
            dateObject = lastDate;
        }
        
        NSDictionary *youtubeQuery = [NSDictionary dictionary];
        
        
        youtubeQuery = [self youtubeQuerywithDate:lastCheckDate setBefore:NO];
        [self downloadVideosWithAPImanager:youtubeAPImanager
                                     query:youtubeQuery
                                 NewVideos:YES];
        
        youtubeQuery = [self youtubeQuerywithDate:lastCheckDate setBefore:YES];
        [self downloadVideosWithAPImanager:youtubeAPImanager
                                     query:youtubeQuery
                               NewVideos:NO];
        
        
        /* Update saved date with current date */
        [dateObject setValue:[NSDate date] forKey:@"date"];
        
        if (![_managedObjectContext save:&error]) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
}

-(void)downloadVideosWithAPImanager:(RKObjectManager *)APImanager query:(NSDictionary *)query NewVideos:(BOOL)isNewVideos
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APImanager getObjectsAtPath:@"v3/search"
                             parameters:query
                                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                    
                                    NSMutableArray *videos = [NSMutableArray array];
                                    
                                    BOOL hasResults = ([[mappingResult array] count] == 0) ? NO : YES;
                                    if (hasResults) {
                                        [videos addObjectsFromArray:[self removeDeletedVideos:[mappingResult array]]];
                                        
                                        if (isNewVideos) {
                                            [[_videos objectAtIndex:videoTypeNew] setArray:videos];
                                        } else {
                                            [[_videos objectAtIndex:videoTypeOld] setArray:videos];
                                        }
                                    }
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [self.tableView reloadData];
                                        
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                    });

                                    
                                }
     
                                failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                    NSLog(@"Error: %@", [error localizedDescription]);
                                }];

}


-(NSDictionary *)youtubeQuerywithDate:(NSDate *)date setBefore:(BOOL)setBefore
{
    
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"snippet", @"part",
                                        _channelID, @"channelId",
                                        kAPIKEY, @"key",
                                        nil];
    
    NSString *dateFormate = [self dateToYoutubeFormate:date];                                    
    if (setBefore) {
        [queryParams setObject:dateFormate forKey:@"publishedBefore"];
    } else {
        [queryParams setObject:dateFormate forKey:@"publishedAfter"];
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

-(NSMutableArray *)removeDeletedVideos:(NSArray *)videos
{
    NSMutableArray *presentVideos = [NSMutableArray array];
    
    for (Video *video in videos) {
        bool isVideoDeleted = [self isVideoDeleted:video.ID];
        if (!isVideoDeleted) {
            [presentVideos addObject:video];
        }
    }
    
    return presentVideos;
}

-(BOOL)isVideoDeleted:(NSString *)videoID
{
    BOOL isVideoDeleted = NO;
    if (videoID) {
        NSString *url = [NSString stringWithFormat:@"%@%@", @"http://gdata.youtube.com/feeds/api/videos/", videoID];
        NSURLRequest *resquest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:resquest
                              returningResponse:&response
                                          error:&error];
        
        if (!error){
            if (response.statusCode == 404) {
                isVideoDeleted = YES;
            } else {
                isVideoDeleted = NO;
            }
        } else {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    } else {
        isVideoDeleted = YES;
    }
    
    return isVideoDeleted;
    
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
    
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    if (cell == nil) {
        cell = [[VideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:videoCellIdentifier];
        
    }
    
    Video *video = [[_videos objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.tumbnailView.image = [UIImage imageNamed:videoCellTumbnailPlaceholder];
    
    [cell.videoTitle setText:video.title];
                                
    cell.tumbnailView.imageURL = [NSURL URLWithString:[[video.thumbnails objectForKey:@"high"] objectForKey:@"url"]];
                                
    return cell;
}

-(void)videoCell:(VideoCell *)videoCell didTapPlayButton:(UIButton *)button
{
    NSIndexPath *videoCellIndex = [self.tableView indexPathForCell:videoCell];
    
    Video *videoData = [[_videos objectAtIndex:videoCellIndex.section] objectAtIndex:videoCellIndex.row];
    
    CustomYouTubeVideoPlayerViewController *videoPlayerViewController = [[CustomYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoData.ID];
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