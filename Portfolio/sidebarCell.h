//
//  sidebarCell.h
//  Portfolio
//
//  Created by PC on 4/25/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarCell : UITableViewCell

@property(nonatomic, strong)UIImageView *icon;
@property(nonatomic, strong)UILabel *description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;



@end
