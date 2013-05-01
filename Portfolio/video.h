//
//  video.h
//  Portfolio
//
//  Created by PC on 3/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "snippet.h"
#import "player.h"

@interface video : NSObject

@property(nonatomic,strong) NSString *ID;
@property(nonatomic, strong) snippet *snippet;
@property(nonatomic, strong) player *player;

@end
