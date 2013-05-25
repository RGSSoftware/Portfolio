//
//  videoViewController.h
//  Portfolio
//
//  Created by PC on 4/22/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kAPIKEY "AIzaSyD1zIG_HErAICBi355-nPLzaxdAY71egIQ"

@interface videoViewController : UITableViewController
{
     NSMutableArray *_videoCategories;
}
 @property(strong, nonatomic) UISegmentedControl *segmentedControl;
@end
