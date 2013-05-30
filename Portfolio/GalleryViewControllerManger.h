//
//  gallerViewControllerManger.h
//  Portfolio
//
//  Created by PC on 5/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GalleryViewController.h"
#import "videoViewController.h"

typedef enum {
    GalleryCategorySignature,
    GalleryCategoryRaw,
} GalleryCategory;

@interface GalleryViewControllerManger : NSObject



@property (strong, nonatomic)NSMutableArray *galleryViewControllers;
@property (strong,nonatomic) NSMutableArray *photoSizes;

- (id)galleryViewController:(GalleryCategory)gallerycategory;
+ (GalleryViewControllerManger *)sharedManager;

@end
