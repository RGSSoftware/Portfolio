//
//  RGSGalleryViewControllerManger.m
//  Portfolio
//
//  Created by PC on 7/8/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "RGSGalleryViewControllerManger.h"
#import "GalleryViewController.h"

#import "ConfigManager.h"

#import "MenuBarButtons.h"
#import "MFSideMenuContainerViewController.h"

#import "SDSegmentedControl.h"

float const categoryControlx = 0;
float const categoryControly = 0;
float const categoryControlheight = 35.f;

float const categoryVideosViewx = 0;
float const categoryVideosViewy = categoryControlheight;

@interface RGSGalleryViewControllerManger ()

@property(nonatomic, strong)MenuBarButtons *menuBarButtons;
@property(nonatomic, strong)SDSegmentedControl *segmentedControl;

@property (strong, nonatomic)NSMutableArray *galleryViewControllers;
@property (strong, nonatomic)NSMutableArray *photoSizes;

@property(nonatomic, weak)UIViewController *currentViewCategoryController;

@end

@implementation RGSGalleryViewControllerManger

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
	// Do any additional setup after loading the view.
    
    _photoSizes = [NSMutableArray array];
    [_photoSizes addObject:[[[ConfigManager sharedManager] galleryConfig] objectForKey:@"sigutrePhotosSizes"]];
    [_photoSizes addObject:[[[ConfigManager sharedManager] galleryConfig] objectForKey:@"rawPhotosSizes"]];
    
    if (!_galleryViewControllers) {
        _galleryViewControllers = [NSMutableArray new];
        
        [_galleryViewControllers addObject:[self galleryViewControllerWithCategory:GalleryCategorySignature andPthsizes:[_photoSizes objectAtIndex:GalleryCategorySignature]]];
        [_galleryViewControllers addObject:[self galleryViewControllerWithCategory:GalleryCategoryRaw andPthsizes:[_photoSizes objectAtIndex:GalleryCategoryRaw]]];
    }
    
    _currentViewCategoryController = [_galleryViewControllers objectAtIndex:0];
    _currentViewCategoryController.view.frame = CGRectMake(categoryVideosViewx, categoryVideosViewy, self.view.frame.size.width, self.view.frame.size.height-categoryVideosViewy);
    [self addChildViewController:_currentViewCategoryController];
    [self.view addSubview:_currentViewCategoryController.view];
    [self.view sendSubviewToBack:_currentViewCategoryController.view];
    [_currentViewCategoryController didMoveToParentViewController:self];
    
    _menuBarButtons = [[MenuBarButtons alloc] initWithParentController:self];
    _menuBarButtons.setLeftBarButton = TRUE;
    [_menuBarButtons setupMenuBarButtonItems];
    
    _segmentedControl = [[SDSegmentedControl alloc] initWithItems:[NSArray arrayWithObjects: @"Signature", @"Raw", nil]];
    _segmentedControl.arrowHeightFactor *= -1.0;
    _segmentedControl.interItemSpace = 5;
    [_segmentedControl addTarget:self action:@selector(changeCategory) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.frame = CGRectMake(categoryControlx, categoryControly, self.view.frame.size.width, categoryControlheight);
    [self.view addSubview:_segmentedControl];
    [self.view bringSubviewToFront:_segmentedControl];


}

- (GalleryViewController *)galleryViewControllerWithCategory:(GalleryCategory)galleycategory andPthsizes:(NSArray *)photosizes
{
    GalleryViewController *galleryController = [[GalleryViewController alloc] initWithCollectionViewLayout:[PintCollectionViewLayout new]];
    galleryController.galleryCategory = galleycategory;
    galleryController.photoSizes = photosizes;
    
    return galleryController;
}

-(void)changeCategory
{
    [_currentViewCategoryController willMoveToParentViewController:nil];
    [_currentViewCategoryController.view removeFromSuperview];
    [_currentViewCategoryController removeFromParentViewController];
    
    _currentViewCategoryController = [_galleryViewControllers objectAtIndex:_segmentedControl.selectedSegmentIndex];
    _currentViewCategoryController.view.frame = CGRectMake(categoryVideosViewx, categoryVideosViewy, self.view.frame.size.width, self.view.frame.size.height-categoryVideosViewy);
    [self addChildViewController:_currentViewCategoryController];
    [self.view addSubview:_currentViewCategoryController.view];
    [self.view sendSubviewToBack:_currentViewCategoryController.view];
    [_currentViewCategoryController didMoveToParentViewController:self];
    
}

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
