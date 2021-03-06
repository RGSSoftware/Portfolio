//
//  photoCell.m
//  recreateBar
//
//  Created by PC on 4/17/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "VideoCell.h"
#import "AsyncImageView.h"

float videoContentX;
float const videoContentY = 5.0f;
float const videoContentWidth = 300.f;
float const videoContentHeight = 240.f;

float const videoTitleX = 5.f;
float const videoTitleY = 6.0f;
float const videoTitleWidth = videoContentWidth - 10;
float const videoTitleHeight = 20.f;

float const videoTumbnailX = 5.f;
float const videoTumbnailY = videoTitleHeight + 10;
float const videoTumbnailWidth = videoContentWidth - 10;
float const videoTumbnailHeight = videoContentHeight - 35;

NSString *const playButtonImage = @"playButton.png";
float const playButtonWidth = 128.f;
float const playButtonHeight = 90.f;
float const playButtonX = (videoContentWidth / 2) - (playButtonWidth / 2);
float const playButtonY = (videoContentHeight / 2) - (playButtonHeight / 2) + 10;


@interface VideoCell ()
@property UIButton *playButton;
@end

@implementation VideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.videoCellWidth = videoContentWidth;
        self.videoCellHeight = videoContentHeight;
        
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        videoContentX = (screenBounds.size.width/2) - (videoContentWidth/2);
        UIView *videoContent = [[UIView alloc] initWithFrame:CGRectMake( videoContentX, videoContentY, videoContentWidth, videoContentHeight)];
        videoContent.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:videoContent];
        
        // Create Title label
        self.videoTitle = [UILabel new];
        self.videoTitle.frame = CGRectMake(videoTitleX, videoTitleY, videoTitleWidth, videoTitleHeight);
        [self.videoTitle setBackgroundColor:[UIColor clearColor]];
        [videoContent addSubview:self.videoTitle];
        
         //Create video Tumbnail(image)
        self.tumbnailView = [UIImageView new];
        self.tumbnailView.frame = CGRectMake( videoTumbnailX, videoTumbnailY, videoTumbnailWidth, videoTumbnailHeight);
        self.imageView.backgroundColor = [UIColor blackColor];
        [videoContent addSubview:self.tumbnailView];
        
        //Create play buton
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake( playButtonX, playButtonY, playButtonWidth, playButtonHeight);
        [self.playButton setBackgroundImage:[UIImage imageNamed:playButtonImage] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(didTapPlayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [videoContent addSubview:self.playButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.videoTitle.frame = CGRectMake(videoTitleX, videoTitleY, videoTitleWidth, videoTitleHeight);
    self.tumbnailView.frame = CGRectMake( videoTumbnailX, videoTumbnailY, videoTumbnailWidth, videoTumbnailHeight);
    self.playButton.frame = CGRectMake( playButtonX, playButtonY, playButtonWidth, playButtonHeight);
}

-(void)didTapPlayButtonAction:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(videoCell:didTapPlayButton:)]) {
        //NSLog(@"inside did tapPlayButton!!!!");
        [self.delegate videoCell:self didTapPlayButton:sender];
    }
}

@end
