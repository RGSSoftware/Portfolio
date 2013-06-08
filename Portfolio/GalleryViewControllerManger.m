//
//  gallerViewControllerManger.m
//  Portfolio
//
//  Created by PC on 5/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "GalleryViewController.h"
#import "GalleryViewControllerManger.h"
#import "ConfigManager.h"

#import "RGSAppDelegate.h"

#import "MFSideMenuContainerViewController.h"

@implementation GalleryViewControllerManger

-(id)init
{
    if ((self = [super init])) {
        
        _photoSizes = [NSMutableArray array];
        [_photoSizes addObject:[[[ConfigManager sharedManager] galleryConfig] objectForKey:@"sigutrePhotosSizes"]];
        [_photoSizes addObject:[[[ConfigManager sharedManager] galleryConfig] objectForKey:@"rawPhotosSizes"]];
    }

    return self;
}

+ (GalleryViewControllerManger *)sharedManager
{
    static GalleryViewControllerManger *sharedManager = nil;
    if (sharedManager == nil)
    {
        sharedManager = [[GalleryViewControllerManger alloc] init];
    }
    return sharedManager;
}

-(GalleryViewController *)galleryViewController:(GalleryCategory)gallerycategory
{
    if (!_galleryViewControllers) {
        _galleryViewControllers = [NSMutableArray new];
        
        [_galleryViewControllers addObject:[self galleryViewController:GalleryCategorySignature pthsize:[_photoSizes objectAtIndex:0]]];
        [_galleryViewControllers addObject:[self galleryViewController:GalleryCategoryRaw pthsize:[_photoSizes objectAtIndex:1]]];
        
        return [_galleryViewControllers objectAtIndex:gallerycategory];
    }
    
    return [_galleryViewControllers objectAtIndex:gallerycategory];
    
}

-(GalleryViewController *)galleryViewController:(GalleryCategory)gallerycategory pthsize:(NSMutableArray *)photosizes
{
    GalleryViewController *galleryController = [GalleryViewController new];
    galleryController.galleryCategory = gallerycategory;
    galleryController.photoSizes = photosizes;
    
    return galleryController;
}

-(void)changeCategory:(GalleryCategory)galleryctegory
{
}



@end
