//
//  ConfigManager.m
//  Portfolio
//
//  Created by PC on 4/30/13.
//  Copyright (c) 2013 PC. All rights reserved.
//
#import "DEBUGHeader.h"

#import "ConfigManager.h"
#import <Parse/Parse.h>
#import <dispatch/dispatch.h>

#import "ImageSize.h"

@implementation ConfigManager

-(id)init
{
    if ((self = [super init])) {
#ifdef MYDEBUG
        NSLog(@"DEBUG MODE");
        
        _galleryConfig = [NSMutableDictionary new];
        
        NSMutableArray *sigutrePhotos = [NSMutableArray array];
        [_galleryConfig setObject:sigutrePhotos forKey:@"sigutrePhotosSizes"];
        
        NSMutableArray *rawPhotosSizes = [NSMutableArray array];
        [_galleryConfig setObject:sigutrePhotos forKey:@"rawPhotosSizes"];
        for (int i = 0; i < 9; i++) {
            UIImage *image = [UIImage imageNamed:@"photo3.jpg"];
            
            ImageSize *imageSize = [ImageSize new];
            imageSize.height = image.size.height;
            imageSize.width = image.size.width;
            [rawPhotosSizes addObject:imageSize];
            sigutrePhotos[i] = imageSize;
        }
        
        [_galleryConfig setObject:[NSNumber numberWithInteger:(rawPhotosSizes.count + sigutrePhotos.count)] forKey:@"photosCount"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(.5);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfigsFinishedDownLoading" object:nil];
            });
        });


        

#else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           /*
            _shortFilmsConfig = [self downloadedShortFilmsConfig];
            _contactConfig = [self downloadedContactConfig];
            _aboutMeConfig = [self downloadedAboutMeConfig];
            */
            _galleryConfig = [NSMutableDictionary new];
            [self getphotosSizes];
            NSLog(@"sigutrePhotosSize count:%d", [[_galleryConfig objectForKey:@"sigutrePhotosSizes"] count]);
            NSLog(@"photos count:%@", [_galleryConfig objectForKey:@"photosCount"]);
            
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ConfigsFinishedDownLoading" object:nil];
            });
        });
        
#endif /* MYDEBUG */
       
    }
    return self;
}

+ (ConfigManager *)sharedManager
{
    static ConfigManager *sharedManager = nil;
    if (sharedManager == nil)
    {
        sharedManager = [[ConfigManager alloc] init];
    }
    return sharedManager;
}

-(id)downloadedShortFilmsConfig
{
    NSDictionary *shortFilmsConfig = [NSDictionary new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"youtube"];
    
    NSArray *objects = [query findObjects];
    PFFile *file = [[objects objectAtIndex:0] objectForKey:@"file"];
    NSData *data = [file getData];
    
    NSLog(@"Succesfully retrieved Youtube config.");
    shortFilmsConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return shortFilmsConfig;
    
};

-(id)downloadedContactConfig
{
    NSDictionary *contactConfig = [NSDictionary new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"contact"];
    
    NSArray *objects = [query findObjects];
    PFFile *file = [[objects objectAtIndex:0] objectForKey:@"file"];
    NSData *data = [file getData];
    
    NSLog(@"Succesfully retrieved Contact config.");
    contactConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return contactConfig;

};

-(id)downloadedAboutMeConfig
{
    NSDictionary *aboutMeConfig = [NSDictionary new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    [query whereKey:@"controller" equalTo:@"aboutMe"];
    
    NSArray *objects = [query findObjects];
    PFFile *file = [[objects objectAtIndex:0] objectForKey:@"file"];
    NSData *data = [file getData];
    
    NSLog(@"Succesfully retrieved AboutMe config.");
    aboutMeConfig = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:NULL error:NULL];
    
    return aboutMeConfig;
    
};

-(void)getphotosSizes
{
    //NSMutableArray *imageSizes = [NSMutableArray array];
    
    PFQuery *query = [PFQuery queryWithClassName:@"photos"];
    NSArray *objects = [query findObjects];

    
    [_galleryConfig setObject:[NSNumber numberWithInteger:objects.count] forKey:@"photosCount"];
    
    NSLog(@"Successfully retrieved %d photos.", objects.count);
    NSMutableArray *sigutrePhotos = [NSMutableArray array];
    [_galleryConfig setObject:sigutrePhotos forKey:@"sigutrePhotosSizes"];
    
    NSMutableArray *rawPhotosSizes = [NSMutableArray array];
    [_galleryConfig setObject:sigutrePhotos forKey:@"rawPhotosSizes"];
    
    for (PFObject *eachobject in objects) {
        BOOL isPhotoRaw = [[eachobject objectForKey:@"raw"] boolValue];
        
        if (isPhotoRaw) {
            NSData *objectData = [[eachobject objectForKey:@"tumbnail"] getData];
            UIImage *image = [UIImage imageWithData:objectData];
            
            ImageSize *imageSize = [ImageSize new];
            imageSize.height = image.size.height;
            imageSize.width = image.size.width;
            [rawPhotosSizes addObject:imageSize];
        }else {
            NSData *objectData = [[eachobject objectForKey:@"tumbnail"] getData];
            UIImage *image = [UIImage imageWithData:objectData];
            
            ImageSize *imageSize = [ImageSize new];
            imageSize.height = image.size.height;
            imageSize.width = image.size.width;
            [sigutrePhotos addObject:imageSize];
            
        }
    }
    
}
@end
