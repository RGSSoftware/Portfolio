//
//  galleryViewController.m
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//
#import "DEBUGHeader.h"

#import "ImageSize.h"

#import "GalleryViewController.h"
#import "PhotoDetailViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "SDSegmentedControl.h"
#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"



#import "SideMenuViewController.h"


#import "ConfigManager.h"

const float kCollectionCellBorderTop = 0;
const float kCollectionCellBorderBottom = 0;
const float kCollectionCellBorderLeft = 0;
const float kCollectionCellBorderRight = 0;

const float kCollectionCloumnWidth = 158.0;
const float kCollectionCloumnCount = 2;

@interface GalleryViewController ()
@property (strong,nonatomic) SDSegmentedControl *categorySegment;

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) MenuBarButtons *menuBarButtons;

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
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];

    PintCollectionViewLayout* customLayout = (PintCollectionViewLayout*)self.collectionView.collectionViewLayout;
    customLayout.interitemSpacing = 4.0;
    customLayout.lineSpacing = 4.0;
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
    
    self.navigationItem.title = @"Galley";
#ifdef MYDEBUG
    /* JUST SKIPPING DOWNLOADING OF IMAGES */
#else
    if (!_photoObjects) {
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
#endif /* MYDEBUG */
    
}

-(NSMutableArray *)downloadPhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"photos"];
    
    if (self.galleryCategory == GalleryCategorySignature) {
        [query whereKey:@"raw" notEqualTo:[NSNumber numberWithBool:TRUE]];
    } else {
        [query whereKey:@"raw" equalTo:[NSNumber numberWithBool:TRUE]];
        [query orderByAscending:@"tunmbnail"];
    }
    NSArray *objects = [query findObjects];
    
    NSLog(@"Successfully retrieved %d photos objects.", objects.count);
    
    return [NSMutableArray arrayWithArray:objects];
   
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *photo = _photoObjects[indexPath.row];
    PFFile *photoThumbnail = [photo objectForKey:@"fullSize"];
    
    PFImageView *imageView = [PFImageView new];
    imageView.file = photoThumbnail;
    [imageView loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            PhotoDetailViewController *pdvc = [[PhotoDetailViewController alloc] init];
            pdvc.selectedImage = image;
            
          [self presentModalViewController:pdvc animated:YES];  
        }
    }];
    [imageView setNeedsDisplay];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)columnWidthForCollectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    return kCollectionCloumnWidth;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return kCollectionCloumnCount;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
   
    ImageSize *imagesize = (ImageSize *)[_photoSizes objectAtIndex:indexPath.row];
    CGSize rctSizeOriginal = CGSizeMake(imagesize.width, imagesize.height);
    double scale = (kCollectionCloumnWidth  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    CGFloat height = rctSizeFinal.height;
    
    return height;
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
     
    // remove subviews from previous usage of this cell
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
#ifdef MYDEBUG
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo3.jpg"]];
    CGSize rctSizeOriginal = imageView.image.size;
    double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);
    
    
    [cell.contentView addSubview:imageView];
    
    return cell;
    
#else
     if (!_photoObjects) {
        return cell;
    } else {
        
        PFObject *photo = _photoObjects[indexPath.row];
        PFFile *photoThumbnail = [photo objectForKey:@"tumbnail"];
        
        PFImageView *imageView = [PFImageView new];
        imageView.file = photoThumbnail;
        [imageView loadInBackground:^(UIImage *image, NSError *error) {
            
            CGSize rctSizeOriginal = image.size;
            double scale = (cell.bounds.size.width  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
            CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
            imageView.frame = CGRectMake(kCollectionCellBorderLeft,kCollectionCellBorderTop,rctSizeFinal.width,rctSizeFinal.height);

            
            [cell.contentView addSubview:imageView];
        }];
    }
    
    return cell;
#endif /* MYDEUG */
    
}
#pragma mark - MenuBarButtonProcol Callbacks

- (void)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)leftSideMenuButtonPressed:(id)sender {
    [_menuBarButtons.menuContainerViewController toggleLeftSideMenuCompletion:^{
        [_menuBarButtons setupMenuBarButtonItems];
    }];
}

- (void)rightSideMenuButtonPressed:(id)sender {
    [_menuBarButtons.menuContainerViewController toggleRightSideMenuCompletion:^{
        [_menuBarButtons setupMenuBarButtonItems];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
