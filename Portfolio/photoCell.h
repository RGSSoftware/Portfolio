//
//  photoCell.h
//  recreateBar
//
//  Created by PC on 4/17/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface photoCell : UITableViewCell

@property (nonatomic, strong) UILabel *userButton;
@property (nonatomic, strong) AsyncImageView *imageView;
@property (nonatomic, strong) UIButton *photoButton;



@end
