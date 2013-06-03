//
//  photoCell.m
//  recreateBar
//
//  Created by PC on 4/17/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "VideoCell.h"
#import "AsyncImageView.h"

#define videoContentX 10.0f
#define videoContentY 5.0f
#define videoContentWidth 300.f
#define videoContentHeight 240.f

#define videoTitleX 5.f
#define videoTitleY 6.0f
#define videoTitleWidth videoContentWidth - 10
#define videoTitleHeight 20.f

#define videoTumbnailX 5.f
#define videoTumbnailY videoTitleHeight + 10
#define videoTumbnailWidth videoContentWidth - 10
#define videoTumbnailHeight videoContentHeight - 35
@implementation VideoCell

@synthesize userButton;
@synthesize imageView;
@synthesize photoButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
       
        UIView *videoContent = [[UIView alloc] initWithFrame:CGRectMake( videoContentX, videoContentY, videoContentWidth, videoContentHeight)];
        videoContent.backgroundColor = [UIColor whiteColor];
        
        // Create Title label
        NSString *nameString = @"TEST STRING";
        self.userButton = [UILabel new];
        self.userButton.frame = CGRectMake(videoTitleX, videoTitleY, videoTitleWidth, videoTitleHeight);
        [self.userButton setBackgroundColor:[UIColor clearColor]];
        [self.userButton setText:nameString];
       // [[self.userButton titleLabel] setFont:[UIFont boldSystemFontOfSize:15.0f]];
        //[[self.userButton titleLabel] setTextAlignment:NSTextAlignmentLeft];
        //[self.userButton setTitle:nameString forState:UIControlStateNormal];
        //[self.userButton setTitleColor:[UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        //[self.userButton setTitleColor:[UIColor colorWithRed:134.0f/255.0f green:100.0f/255.0f blue:65.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
       // [[self.userButton titleLabel] setLineBreakMode:UILineBreakModeTailTruncation];
        //[[self.userButton titleLabel] setShadowOffset:CGSizeMake(0.0f, 1.0f)];
        
        //[self.userButton setTitleShadowColor:[UIColor colorWithWhite:1.0f alpha:0.750f] forState:UIControlStateNormal];
        //[userButton addTarget:self action:@selector(didTapUserNameButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [videoContent addSubview:self.userButton];
        
        //Create play buton
        UIImageView *playButton = [UIImageView new];
        playButton.frame = CGRectMake( videoTumbnailX+80, videoTumbnailY+60, 100.f, 100.f);
        playButton.image = [UIImage imageNamed:@"playButton.png"];
        [videoContent addSubview:playButton];
        
        //Create video Tumbnail(image)
        self.imageView = [UIImageView new];
        self.imageView.frame = CGRectMake( videoTumbnailX, videoTumbnailY, videoTumbnailWidth, videoTumbnailHeight);
        self.imageView.backgroundColor = [UIColor blackColor];
        //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [videoContent addSubview:self.imageView];
        
        self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoButton.frame = CGRectMake( videoTumbnailX, videoTumbnailY, videoTumbnailWidth, videoTumbnailHeight);
        self.photoButton.backgroundColor = [UIColor clearColor];
        [videoContent addSubview:self.photoButton];
        
        [videoContent bringSubviewToFront:playButton];
        [self.contentView addSubview:videoContent];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.userButton.frame = CGRectMake(videoTitleX, videoTitleY, videoTitleWidth, videoTitleHeight);
    self.imageView.frame = CGRectMake( videoTumbnailX, videoTumbnailY, videoTumbnailWidth, videoTumbnailHeight);
    self.photoButton.frame = CGRectMake( videoTumbnailX, videoTumbnailY, videoTumbnailWidth, videoTumbnailHeight);
}

@end
