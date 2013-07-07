//
//  video.h
//  Portfolio
//
//  Created by PC on 3/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Video : NSObject

@property(nonatomic,strong) NSString *ID;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *description;

@property(nonatomic, strong)NSMutableDictionary *thumbnails;



@end
