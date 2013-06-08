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

@interface GalleryViewController ()
@property (strong,nonatomic) SDSegmentedControl *categorySegment;

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) MenuBarButtons *menuBarButtons;

@property (strong,nonatomic) NSMutableArray *photoObjects;

@end

#define kCollectionCellBorderTop 0
#define kCollectionCellBorderBottom 0
#define kCollectionCellBorderLeft 0
#define kCollectionCellBorderRight 0

#define kCollectioncCloumnWidth 158.0
#define kCollectionNumCloumn 2



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
    
    
    
    [self initCollectionView];
    
    // Do any additional setup after loading the view from its nib.
    _categorySegment = [[SDSegmentedControl alloc] initWithItems:@[@"Sigature", @"Raw"]];
    _categorySegment.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35.f);
    [_categorySegment addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventValueChanged];
    _categorySegment.arrowHeightFactor = 0;
    _categorySegment.interItemSpace = 10;
    [self.view addSubview:_categorySegment];
    
    if (_galleryCategory == GalleryCategoryRaw) {
        [self changeCategorySegmentButton:GalleryCategoryRaw];
    }
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
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
    
    self.navigationItem.title = @"Galley";

}
-(void)next
{
    if (_categorySegment.selectedSegmentIndex == 0) {
        _categorySegment.selectedSegmentIndex = 1;
    } else if (_categorySegment.selectedSegmentIndex == 1){
        _categorySegment.selectedSegmentIndex = 0;
    }
}

-(void)changeCategorySegmentButton:(GalleryCategory)galleryCategory
{
    if (galleryCategory == GalleryCategorySignature) {
        _categorySegment.selectedSegmentIndex = 0;
    } else {
        _categorySegment.selectedSegmentIndex = 1;
    }
}

-(void)changeCategory
{
    NSLog(@"tounched %d", _categorySegment.selectedSegmentIndex);
        /*
_collectionView = nil;
    [self initCollectionView];
    [self.collectionView reloadData];
    */
    if (_categorySegment.selectedSegmentIndex == 0) {
        GalleryViewController *sategory = [[GalleryViewControllerManger sharedManager] galleryViewController:GalleryCategorySignature];
        [sategory changeCategorySegmentButton:GalleryCategorySignature];
        self.navigationController.viewControllers = @[sategory];
        
        NSLog(@"signture");
        
    }
    else if (_categorySegment.selectedSegmentIndex == 1) {
        GalleryViewController *sategory = [[GalleryViewControllerManger sharedManager] galleryViewController:GalleryCategoryRaw];
        [sategory changeCategorySegmentButton:GalleryCategoryRaw];
        self.navigationController.viewControllers = @[sategory];
        
        NSLog(@"raw gategory");
    }
}

-(void)initCollectionView
{
    _collectionView = [[UICollectionView  alloc] initWithFrame:CGRectMake(0, 35.f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 80.f) collectionViewLayout:[PintCollectionViewLayout new]] ;
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    self.collectionView.collectionViewLayout = [PintCollectionViewLayout new];
    // set up delegates
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // set inter-item spacing in the layout
    PintCollectionViewLayout* customLayout = (PintCollectionViewLayout*)self.collectionView.collectionViewLayout;
    customLayout.interitemSpacing = 4.0;
    customLayout.lineSpacing = 4.0;
}

-(NSMutableArray *)downloadPhotos
{
   // NSMutableArray *photos = [NSMutableArray new];
    
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
    /*
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
     
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return kCollectioncCloumnWidth;
}

- (NSUInteger)maximumNumberOfColumnsForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
{
    return kCollectionNumCloumn;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
   
    ImageSize *imagesize = (ImageSize *)[_photoSizes objectAtIndex:indexPath.row];
    CGSize rctSizeOriginal = CGSizeMake(imagesize.width, imagesize.height);
    double scale = (kCollectioncCloumnWidth  - (kCollectionCellBorderLeft + kCollectionCellBorderRight)) / rctSizeOriginal.width;
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


@end
