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

NSString *const ConfigManagerDidCompleteConfigDownloadNotification = @"ConfigManagerDidCompleteConfigDownloadNotification";

typedef enum{
    PhotoTypeRaw,
    PhotoTypeSignature,
}PhotoType;

@implementation ConfigManager

-(id)init
{
    if ((self = [super init])) {
#ifdef MYDEBUG
        NSLog(@"DEBUG MODE");
        
        /*
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
        ;
        */
        
        
        
        NSMutableArray *icons = [NSMutableArray new];
        for (int i = 0; i < 5; i++) {
            NSMutableDictionary *button = [NSMutableDictionary new];
            [icons addObject:button];
            
            UIImage *iconImage = [UIImage imageNamed:@"AboutMe.png"];
            [button setObject:iconImage forKey:@"iconImage"];
            
            NSString *description = @"test";
            [button setObject:description forKey:@"description"];
        }
        _sideMenuConfig = [NSMutableDictionary dictionaryWithObject:icons forKey:@"Icons"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //sleep(.5);
            
            _galleryConfig = [NSMutableDictionary new];
            [_galleryConfig setObject:[self photoSizesFromType:PhotoTypeRaw] forKey:@"RawPhotosSizes"];
            //[_galleryConfig setObject:[self photoSizesFromType:PhotoTypeSignature] forKey:@"SignaturePhotosSizes"   ];
        
            int photoCount = ([[_galleryConfig objectForKey:@"RawPhotosSizes"] count] + [[_galleryConfig objectForKey:@"SignturePhotosSizes"] count]);
            [_galleryConfig setObject:[NSNumber numberWithInteger:photoCount] forKey:@"photosCount"];
            dispatch_async(dispatch_get_main_queue(), ^{
               // [[NSNotificationCenter defaultCenter] postNotificationName:ConfigManagerDidCompleteConfigDownloadNotification object:nil];
            });
        });

#else
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            [self initConfigFiles];
            _sideMenuConfig = [NSMutableDictionary dictionaryWithObject:[self getSideMenuIcons] forKey:@"Icons"];
           
            _galleryConfig = [NSMutableDictionary new];
            [_galleryConfig setObject:[self photoSizesFromType:PhotoTypeRaw] forKey:@"rawPhotosSizes"];
            [_galleryConfig setObject:[self photoSizesFromType:PhotoTypeSignature] forKey:@"signaturePhotosSizes"];
            
            int photoCount = ([[_galleryConfig objectForKey:@"RawPhotosSizes"] count] + [[_galleryConfig objectForKey:@"SignturePhotosSizes"] count]);
            [_galleryConfig setObject:[NSNumber numberWithInteger:photoCount] forKey:@"photosCount"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self customizeAppearance];
                [[NSNotificationCenter defaultCenter] postNotificationName:ConfigManagerDidCompleteConfigDownloadNotification object:nil];
            });
        });
        
#endif /* MYDEBUG */
       
    }
    return self;
}

+ (ConfigManager *)sharedManager
{
    static ConfigManager *sharedManager = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
-(void)customizeAppearance{
    //Set the background image for *all* UINavigationBars across the app
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBar_background"]
                                       forBarMetrics:UIBarMetricsDefault];
    
}

-(NSMutableArray *)photoSizesFromType:(PhotoType)phtype
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    
    if (phtype == PhotoTypeRaw) {
        [query whereKey:@"isRaw" equalTo:[NSNumber numberWithBool:TRUE]];
    } else if (phtype == PhotoTypeSignature){
        [query whereKey:@"isRaw" equalTo:[NSNumber numberWithBool:FALSE]];
    }
    
    [query addAscendingOrder:@"objectId"];
    [query includeKey:@"thumbnail"];
    NSArray *objects = [query findObjects];
    
    NSMutableArray *photoSizes = [NSMutableArray array];
    
    for (PFObject *eachObject in objects) {
        
        PFObject *imageObject = [[eachObject objectForKey:@"thumbnail"] fetchIfNeeded];
        
        float width = [[imageObject objectForKey:@"width"] integerValue];
        float height = [[imageObject objectForKey:@"height"] integerValue];
        
        CGSize imageSize = CGSizeMake(width, height);
        [photoSizes addObject:[NSValue valueWithCGSize:imageSize]];
        
        NSLog(@"height:%f width %f", imageSize.height, imageSize.width);
    }
    
    return photoSizes;
}

-(NSArray *)getSideMenuIcons
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
-(void)initConfigFiles
{
    PFQuery *query = [PFQuery queryWithClassName:@"Config"];
    NSArray *objects = [query findObjects];
    
    for (PFObject *eachobject in objects) {
        NSString *controllerName = [eachobject objectForKey:@"controller"];
        PFFile *dataFile = [eachobject objectForKey:@"file"];
        
        if ([controllerName isEqualToString:@"aboutMe"]) {
            
            _aboutMeConfig = [self downloadConfigForFile:dataFile];
            NSLog(@"Succesfully retrieved AboutMe config.");
        
        }
        else if ([controllerName isEqualToString:@"contact"]){
            
            _contactConfig = [self downloadConfigForFile:dataFile];
            NSLog(@"Succesfully retrieved Contact config.");
  
        }
        else if ([controllerName isEqualToString:@"youtube"]){
            
          _shortFilmsConfig = [self downloadConfigForFile:dataFile];
            NSLog(@"Succesfully retrieved Youtube config.");
            
        }
        else {
            NSLog(@"Error: %@%@", @"Unexpected Config data from parse:", @"query with class name{Config}");
        }
    }
}
-(NSDictionary *)downloadConfigForFile:(PFFile *)file
{
    NSData *data = [file getData];
    
    return [NSDictionary dictionaryWithDictionary:[NSPropertyListSerialization propertyListWithData:data
                                                                                            options:NSPropertyListMutableContainersAndLeaves
                                                                                             format:NULL
                                                                                              error:NULL]];
}

@end
