//
//  galleryViewController.h
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalleryViewControllerManger.h"

#import "PintCollectionViewLayout.h"

@interface GalleryViewController : UIViewController <UICollectionViewDelegateJSPintLayout,UICollectionViewDataSource>



//@property (nonatomic) GalleryCategory galleryCategory;

@property (strong,nonatomic) NSMutableArray *photoSizes;



@end
