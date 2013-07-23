//
//  galleryViewController.h
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RGSGalleryViewControllerManger.h"

#import "PintCollectionViewLayout.h"

//@class GalleryViewControllerManger;
@interface GalleryViewController : UIViewController <UICollectionViewDelegateJSPintLayout,UICollectionViewDataSource>



@property (nonatomic, assign) GalleryCategory galleryCategory;

@property (strong,nonatomic) NSArray *photoSizes;

-(void)changeCategorySegmentButton:(GalleryCategory)galleryCategory;


@end
