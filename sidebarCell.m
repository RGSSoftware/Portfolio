//
//  sidebarCell.m
//  Portfolio
//
//  Created by PC on 4/25/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import "sidebarCell.h"

@implementation sidebarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(22, 10, 35, 35)];
        [self addSubview:_icon];
        
        self.description = [[UILabel alloc] initWithFrame:CGRectMake(5, 47, 70, 20)];
        [self.description setBackgroundColor:[UIColor clearColor]];
        [self.description setTextAlignment:NSTextAlignmentCenter];
        [self.description setFont:[UIFont boldSystemFontOfSize:11]];
        [self.description setTextColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1]];
        [self addSubview:_description];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
