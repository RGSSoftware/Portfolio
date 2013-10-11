//
//  galleryViewController.m
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "GalleryViewController.h"
#import "PhotoDetailViewController.h"

#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "GGFullScreenImageViewController.h"
#import "SDSegmentedControl.h"
#import "MenuBarButtons.h"


#import "ConfigManager.h"

#import "FRGWaterfallCollectionViewCell.h"

const float kCollectionCellBorderTop = 0;
const float kCollectionCellBorderBottom = 0;
const float kCollectionCellBorderLeft = 0;
const float kCollectionCellBorderRight = 0;

const float kCollectionCloumnWidth = 156.0;
const float kCollectionCloumnCount = 2;

static NSString* const WaterfallCellIdentifier = @"WaterfallCell";

@interface GalleryViewController () <FRGWaterfallCollectionViewDelegate>
@property (strong,nonatomic) MenuBarButtons *menuBarButtons;
@property (strong,nonatomic) SDSegmentedControl *categorySegment;

@property (strong,nonatomic) NSMutableArray *photoObjects;
@end

@implementation GalleryViewController

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
    
    
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:WaterfallCellIdentifier];
    
    
    FRGWaterfallCollectionViewLayout *collectionViewLayout = [[FRGWaterfallCollectionViewLayout alloc] init];
    collectionViewLayout.delegate = self;
    collectionViewLayout.itemWidth = 156.0f;
    //collectionViewLayout.headerHeight = 26.0f;
    //collectionViewLayout.topInset = 10.0f;
    //collectionViewLayout.bottomInset = 10.0f;
    //collectionViewLayout.stickyHeader = YES;
    
    [self.collectionView setCollectionViewLayout:collectionViewLayout];
    
    self.navigationItem.title = @"Galley";

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
        NSMutableArray *downloadPhotos = [self downloadPhotos];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            _photoObjects = [NSMutableArray arrayWithArray:downloadPhotos];
            
            [self.collectionView reloadData];
                
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });


    
}

-(NSMutableArray *)downloadPhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    
    if (self.galleryCategory == GalleryCategoryRaw) {
        [query whereKey:@"isRaw" equalTo:[NSNumber numberWithBool:TRUE]];
    } else if (self.galleryCategory == GalleryCategorySignature){
        [query whereKey:@"isRaw" equalTo:[NSNumber numberWithBool:FALSE]];
    }
    [query addAscendingOrder:@"objectId"];
    [query includeKey:@"thumbnail"];
    
    NSError *error = nil;
    NSMutableArray *objects = [NSMutableArray arrayWithArray:[query findObjects:&error]];
    
    if (!error) {
        NSLog(@"Successfully retrieved %d photos objects.", objects.count);
    } else {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    return objects;
   
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    PFObject *photoObject = _photoObjects[indexPath.row];
    [[photoObject objectForKey:@"full"] fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        PFFile *fullSizeFile = [object objectForKey:@"file"];
        
        PFImageView *imageView = [PFImageView new];
        imageView.file = fullSizeFile;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView loadInBackground:^(UIImage *image, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            if (!error) {
                GGFullscreenImageViewController *pdvc = [[GGFullscreenImageViewController alloc] init];
                pdvc.liftedImageView = imageView;
                
                [self presentViewController:pdvc animated:YES completion:Nil];
            } else {
                NSLog(@"Error: %@", [error localizedDescription]);
            }
        }];
        [imageView setNeedsDisplay];
    }];
}



-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CGSize sizeFinal = [self scaleImageSize:[[_photoSizes objectAtIndex:indexPath.row] CGSizeValue] toWidth:kCollectionCloumnWidth];
    return sizeFinal.height;
}

#pragma mark = UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photoSizes count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
    FRGWaterfallCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfallCellIdentifier
                                                                                     forIndexPath:indexPath];
     
    // remove subviews from previous usage of this cell
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    

     if (_photoObjects) {
         PFObject *photoObject = _photoObjects[indexPath.row];
        PFObject *imageObject = [[photoObject objectForKey:@"thumbnail"] fetchIfNeeded];
        PFFile *photoThumbnail = [imageObject objectForKey:@"file"];

        PFImageView *imageView = [PFImageView new];
        imageView.file = photoThumbnail;
        [imageView loadInBackground:^(UIImage *image, NSError *error) {
            
            CGSize imageScaleSize = [self scaleImageSize:image.size toWidth:kCollectionCloumnWidth];
            imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,imageScaleSize.width,imageScaleSize.height);
            
            [cell.contentView addSubview:imageView];
        }];
    }
    
    return cell;

    
}

-(CGSize)scaleImageSize:(CGSize)imgSize toWidth:(NSInteger)toWidth{
    CGSize sizeOriginal = imgSize;
    double scale = (toWidth  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / sizeOriginal.width;
    CGSize sizeFinal = CGSizeMake(sizeOriginal.width * scale,sizeOriginal.height * scale);
    
    return sizeFinal;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
