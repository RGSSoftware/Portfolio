//
//  HorizontalLineView.m
//  youtube
//
//  Created by PC on 2/22/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "HorizontalLineView.h"



@implementation HorizontalLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blueColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, 0.31, 0.31, 0.31, 1.0);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, LINE_START_X, bounds.size.height / 2);
    CGContextAddLineToPoint(ctx, bounds.size.width - LINE_START_X, bounds.size.height / 2);
    
    CGContextStrokePath(ctx);
}


@end
