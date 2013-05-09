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

@interface galleryViewController ()
@property(nonatomic)NSInteger imageLeftWidth;
@property(nonatomic)NSInteger imageMiddleWidth;
@property(nonatomic)NSInteger imageRightWidth;

@property(nonatomic)NSInteger row;
@property(nonatomic)NSInteger rowSumWidth;



@end

@implementation galleryViewController

@synthesize collectionView = _collectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _row = 1;
        
        _photos = [NSMutableArray array];
        
      /*
        NSMutableArray *sigutrePhotos = [NSMutableArray array];
        for (NSInteger i = 0; i < 9; i++) {
            UIImage *sigPh = [UIImage imageNamed:@"baby.jpg"];
            [sigutrePhotos addObject:sigPh];
        }
        [_photos addObject:sigutrePhotos];
    
        NSMutableArray *rawPhotos = [NSMutableArray array];
        for (NSInteger i = 0; i < 15; i++) {
            UIImage *rawPh = [UIImage imageNamed:@"betceemay.jpg"];
            [rawPhotos addObject:rawPh];
        }
        
        NSArray *filenames = [NSArray arrayWithObjects:@"photo15.jpg",@"photo345.jpg", @"photo640.jpg", @"photo153.jpg", @"photo230.jpg", @"photo2640.jpg", nil];
        NSMutableArray *testPhotos = [NSMutableArray array];
        [_photos addObject:testPhotos];
        
        for (int i = 0; i < [filenames count]; i++) {
            UIImage *testPh = [UIImage imageNamed:filenames[i]];
            [testPhotos addObject:testPh];
        }
         */    
    
        
    }
    return self;
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self downloadPhotos];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
   
    
    [self setupMenuBarButtonItems];

    
    
}

-(void)downloadPhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"photos"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            NSMutableArray *sigutrePhotos = [NSMutableArray array];
            [_photos addObject:sigutrePhotos];
            
            NSMutableArray *rawPhotos = [NSMutableArray array];
            [_photos addObject:rawPhotos];
            
            for (PFObject *eachobject in objects) {
                BOOL isPhotoRaw = [[eachobject objectForKey:@"raw"] boolValue];
                
                if (isPhotoRaw) {
                    [rawPhotos addObject:eachobject];
                }else {
                    [sigutrePhotos addObject:eachobject];
                }
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    NSArray *sectionArray = [_photos objectAtIndex:section];
    return [sectionArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [_photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    PFObject *photo = _photos[indexPath.section][indexPath.row];
    PFFile *photoThumbnail = [photo objectForKey:@"tumbnail"];
    
    PFImageView *imageView = [PFImageView new];
    imageView.file = photoThumbnail;
    [imageView loadInBackground];
    
    CGSize cellSize = cell.frame.size;
    imageView.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);

                
    [cell.contentView addSubview:imageView];
    
    return cell;
}

#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *photo = _photos[indexPath.section][indexPath.row];
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

#pragma mark - UICollectionViewFlowLayout Delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (_row == 1 && indexPath.section == 0) {
        if (_imageLeftWidth == 0) {
            float lowBound = 70;
            float highBound = 240;
            float randValue = (((float)arc4random()/0x100000000)*(highBound - lowBound) + lowBound);
            
            float test = randValue;
            _imageLeftWidth = test;
            _imageRightWidth = (rowTotalWidth - _imageLeftWidth) + 1;
            
            return CGSizeMake(_imageLeftWidth, imageHeightMax);
        } else {
            float irw = _imageRightWidth;
            _imageLeftWidth = 0;
            _imageRightWidth = 0;
            _row++;
            return CGSizeMake(irw, imageHeightMax);
            
        }
        
    }
    if (_row == 2 && indexPath.section == 0) {
        if (_imageLeftWidth == 0) {
           
            NSMutableArray *imagewidths = [NSMutableArray array];
            for (int i = 0; i < 2; i++) {
                float lowBound = 80;
                float highBound = 103;
                float randValue = (((float)arc4random()/0x100000000)*(highBound - lowBound) + lowBound);
                
                [imagewidths addObject:[NSNumber numberWithFloat:randValue]];
            }
            
            _imageLeftWidth = [[imagewidths objectAtIndex:0] floatValue];
            _imageRightWidth = [[imagewidths objectAtIndex:1] floatValue];
            
           
            return CGSizeMake(_imageLeftWidth, imageHeightMax);
        } else if (_imageMiddleWidth == 0){
            _imageMiddleWidth = (rowTotalWidth - (_imageLeftWidth + _imageRightWidth)) - 2;
        return CGSizeMake(_imageMiddleWidth, imageHeightMax);
        } else {
            float irw = _imageRightWidth;
            _imageLeftWidth = 0;
            _imageMiddleWidth = 0;
            _imageRightWidth = 0;
            _row = 0;
            return CGSizeMake(irw, imageHeightMax);
        }
    }
    
    */ 
    return CGSizeMake(155, 125);
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3.f, 3.f, 3.f, 3.f);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}


@end
