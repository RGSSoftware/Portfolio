//
//  ConfigManager.h
//  Portfolio
//
//  Created by PC on 4/30/13.
//  Copyright (c) 2013 PC. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ConfigManagerDidCompleteConfigDownloadNotification;
extern NSString *const ConfigManagerDidStartConfigDownloadNotification;
extern NSString *const ConfigManagerDidFailConfigDownloadNotification;

extern NSString *const NavigationBarBackground;

@interface ConfigManager : NSObject

@property(nonatomic, strong)NSDictionary *shortFilmsConfig;
@property(nonatomic, strong)NSDictionary *contactConfig;
@property(nonatomic, strong)NSDictionary *aboutMeConfig;
@property(nonatomic, strong)NSMutableDictionary *galleryConfig;
@property(nonatomic, strong)NSDictionary *sideMenuConfig;

+ (ConfigManager *)sharedManager;

@end
