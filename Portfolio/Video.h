//
//  video.h
//  Portfolio
//
//  Created by PC on 3/28/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGSVideoID.h"
#import "Snippet.h"
#import "Player.h"

@interface Video : NSObject

@property(nonatomic,strong) RGSVideoID *ID;
@property(nonatomic, strong) Snippet *snippet;
@property(nonatomic, strong) Player *player;

@property(nonatomic, strong)NSMutableDictionary *thumbnails;



@end
