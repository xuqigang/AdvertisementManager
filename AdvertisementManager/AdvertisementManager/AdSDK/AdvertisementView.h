//
//  AdvertisementView.h
//  WangHuo
//
//  Created by 韩肖杰 on 2018/12/5.
//  Copyright © 2018 ifeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class AdvertisementModel;
@class AdvertisementView;
@protocol AdvertisementViewDelegate <NSObject>

//倒计时结束，广告停止显示
- (void)advertisementViewStopView:(AdvertisementView*)advertisementView;
//用户点击跳转按钮
- (void)advertisementView:(AdvertisementView*)advertisementView jumpToDetail:(AdvertisementModel*)advertisementModel;

@end

@interface AdvertisementView : UIWindow

@property (nonatomic, strong) AdvertisementModel *advertisementData;
@property (nonatomic, weak) id<AdvertisementViewDelegate> delegate;

+ (instancetype)defaultView;
- (void)invalid;
@end

NS_ASSUME_NONNULL_END
