//
//  photoCell.h
//  recreateBar
//
//  Created by PC on 4/17/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@protocol RGSVideoCellDelegate;


@interface VideoCell : UITableViewCell

@property (nonatomic, strong) UILabel *videoTitle;
@property (nonatomic, strong) UIImageView *tumbnailView;

@property (nonatomic, assign) CGFloat videoCellWidth;
@property (nonatomic, assign) CGFloat videoCellHeight;

@property (nonatomic, weak) id <RGSVideoCellDelegate> delegate;

@end

@protocol RGSVideoCellDelegate <NSObject>

@optional

-(void)videoCell:(VideoCell *)videoCell didTapPlayButton:(UIButton *)button;

@end
