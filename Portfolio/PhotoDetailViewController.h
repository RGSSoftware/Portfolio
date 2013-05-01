//
//  PhotoDetailViewController.h
//  SavingImagesTutorial
//
//  Created by Sidwyn Koh on 29/1/12.
//  Copyright (c) 2012 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PhotoDetailViewController : UIViewController
{
    IBOutlet PFImageView *photoImageView;
    UIImage *selectedImage;
    NSString *imageName;
}
@property (nonatomic, retain) IBOutlet PFImageView *photoImageView;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, retain) NSString *imageName;

- (IBAction)close:(id)sender;
@end
