//
//  galleryViewController.h
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenuController.h"

#define rowTotalWidth 310
#define imageHeightMax 125


@interface galleryViewController : MFSideMenuController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_photos;
}
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
