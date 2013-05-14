//
//  galleryViewController.m
//  Portfolio
//
//  Created by PC on 3/1/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "galleryViewController.h"
#import "PhotoDetailViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "ImageSize.h"

#import "ConfigManager.h"

@interface galleryViewController ()
@property (strong,nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *photoSizes;
@property (strong,nonatomic) NSMutableArray *photoObjects;
@end

#define kCollectionCellBorderTop 0
#define kCollectionCellBorderBottom 0
#define kCollectionCellBorderLeft 0
#define kCollectionCellBorderRight 0

#define kCollectioncCloumnWidth 158.0
#define kCollectionNumCloumn 2

@implementation galleryViewController

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
    // Do any additional setup after loading the view from its nib.
    
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    self.view.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:247.0f/255.0f blue:247.0f/255.0f alpha:1];
    
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
    
    
    self.collectionView.collectionViewLayout = [PintCollectionViewLayout new];
    // set up delegates
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // set inter-item spacing in the layout
    PintCollectionViewLayout* customLayout = (PintCollectionViewLayout*)self.collectionView.collectionViewLayout;
    customLayout.interitemSpacing = 4.0;
    customLayout.lineSpacing = 4.0;
    
   // [self setupMenuBarButtonItems];
    _photoSizes = [NSMutableArray array];
    [_photoSizes addObject:[[[ConfigManager sharedManager] galleryConfig] objectForKey:@"rawPhotosSizes"]];
    [_photoSizes addObject:[[[ConfigManager sharedManager] galleryConfig] objectForKey:@"sigutrePhotosSizes"]];

}

-(NSMutableArray *)downloadPhotos
{
    NSMutableArray *photos = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"photos"];
    NSArray *objects = [query findObjects];
    
    NSLog(@"Successfully retrieved %d photos objects.", objects.count);
    NSMutableArray *sigutrePhotos = [NSMutableArray array];
    [photos addObject:sigutrePhotos];
            
    NSMutableArray *rawPhotos = [NSMutableArray array];
    [photos addObject:rawPhotos];
            
    for (PFObject *eachobject in objects) {
        BOOL isPhotoRaw = [[eachobject objectForKey:@"raw"] boolValue];

        if (isPhotoRaw) {
            [rawPhotos addObject:eachobject];
        }else {
            [sigutrePhotos addObject:eachobject];
        }
    }
    return photos;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *photo = _photoObjects[indexPath.section][indexPath.row];
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
    return kCollectioncCloumnWidth;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return kCollectionNumCloumn;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    ImageSize *imagesize = (ImageSize *)[[_photoSizes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CGSize rctSizeOriginal = CGSizeMake(imagesize.width, imagesize.height);
    double scale = (kCollectioncCloumnWidth  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
    CGSize rctSizeFinal = CGSizeMake(rctSizeOriginal.width * scale,rctSizeOriginal.height * scale);
    CGFloat height = rctSizeFinal.height;
    
    return height;
}

#pragma mark = UICollectionViewDataSource



- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[_photoSizes objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    // remove subviews from previous usage of this cell
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!_photoObjects) {
        return cell;
    } else {
        PFObject *photo = _photoObjects[indexPath.section][indexPath.row];
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
}

@end
