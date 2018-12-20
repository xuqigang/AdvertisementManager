//
//  AdvertisementModel.h
//  WangHuo
//
//  Created by 韩肖杰 on 2018/12/5.
//  Copyright © 2018 ifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdvertisementManager : NSObject

+ (instancetype)defaultManager;
- (void)startup;  //启动广告
+ (void)invalid;  //是否广告资源

@end







@interface AdvertisementModel : NSObject

@property (nonatomic, copy) NSString *clickUrl;
@property (nonatomic, copy) NSString *adImage;
@property (nonatomic, copy) NSString *name;   //首充活动
@property (nonatomic, assign) NSInteger showTime;

@end

NS_ASSUME_NONNULL_END
