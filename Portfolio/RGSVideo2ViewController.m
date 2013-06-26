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
#import "RGSVideoID.h"
#import "Snippet.h"

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
            NSLog(@"%@ -----ID:%@", video.snippet.title,video.ID.videoId);
        }
        NSLog(@"local test data: %@", [result array]);
        
    } failure:nil];
    [operation start];
    
#else
    [youtubeAPImanager addResponseDescriptor:responseDescriptior];
    
 //   [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptior];
    NSDictionary *queryParams = [NSDictionary new];
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:@"snippet", @"part",_channelID, @"channelId",  kAPIKEY, @"key", nil];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSLog(@"sharedManger resonseDecriptior%@", objectManager.responseDescriptors[0]);
    NSLog(@"youtubeAPIManager resonseDecriptior%@", youtubeAPImanager.responseDescriptors[0]);
    
    /*[objectManager getObjectsPath] <------ this was the problem */
    [youtubeAPImanager getObjectsAtPath:@"v3/search" parameters:queryParams
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSLog(@"video count: %d", [[mappingResult array] count]);
                                
                                for (Video *video in [mappingResult array]) {
                                    NSLog(@"%@ -----ID:%@", video.snippet.title,video.ID.videoId);
                                }
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
    //[videoMapping addAttributeMappingsFromDictionary:@{
      //  @"id" : @"ID"
     //}];
   
    
    RKObjectMapping *videoIdMapping = [RKObjectMapping mappingForClass:[RGSVideoID class]];
    [videoIdMapping addAttributeMappingsFromArray:@[@"videoId"]];
    [videoMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"id"
                                                                                 toKeyPath:@"ID"
                                                                               withMapping:videoIdMapping]];
    
     
    
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
    
        
    return videoMapping;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
