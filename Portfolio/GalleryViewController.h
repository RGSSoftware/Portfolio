//
//  galleryViewController.h
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalleryViewControllerContainer.h"

#import "FRGWaterfallCollectionViewLayout.h"


@interface GalleryViewController : UICollectionViewController <UICollectionViewDataSource>

@property (nonatomic, assign) GalleryCategory galleryCategory;
@property (strong,nonatomic) NSArray *photoSizes;

@end
