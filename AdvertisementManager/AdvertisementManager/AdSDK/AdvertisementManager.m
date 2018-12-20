//
//  AdvertisementModel.m
//  WangHuo
//
//  Created by 韩肖杰 on 2018/12/5.
//  Copyright © 2018 ifeng. All rights reserved.
//

#import "AdvertisementManager.h"
#import "AdvertisementView.h"
static AdvertisementManager *advertisementManager;
@interface AdvertisementManager() <AdvertisementViewDelegate>
{
    NSInteger _adIndex;
}
@property (nonatomic, strong) NSMutableArray *advertisementDataSource;
@property (nonatomic, strong) AdvertisementModel *advertisementData;
@property (nonatomic, strong) AdvertisementView *advertisementView;
@end
@implementation AdvertisementManager

+ (void)load{
    [super load];
    [AdvertisementManager defaultManager];
}

+ (instancetype)defaultManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        advertisementManager = [[self alloc] init];
    });
    return advertisementManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        NSInteger index = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AdIndex"] integerValue];
        _adIndex = index;
        index ++;
        [self initAdvertisementData];
        [[NSUserDefaults standardUserDefaults] setObject:@(index) forKey:@"AdIndex"];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            [self startup];
        }];
    }
    return self;
}
- (void)initAdvertisementData{
    self.advertisementDataSource = [NSMutableArray arrayWithCapacity:4];
    NSString *datapath = [[NSBundle mainBundle] pathForResource:@"AdvertisementList" ofType:@"plist"];
    NSArray *list = [NSArray arrayWithContentsOfFile:datapath];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AdvertisementModel *model = [AdvertisementModel new];
        [model setValuesForKeysWithDictionary:obj];
        [self.advertisementDataSource addObject:model];
    }];
}
- (AdvertisementView*)advertisementView{
    if (!_advertisementView) {
        _advertisementView = [AdvertisementView defaultView];
        _advertisementView.delegate = self;
    }
    return _advertisementView;
}
- (void)startup{  //启动广告
    if ([self.advertisementDataSource count] > 0) {
        AdvertisementModel *advertisementModel =  [self.advertisementDataSource objectAtIndex:_adIndex%[self.advertisementDataSource count]];
        [self.advertisementView setAdvertisementData:advertisementModel];
    } else {
        [self.advertisementView invalid];
        self.advertisementView = nil;
        [AdvertisementManager invalid];
    }
}
#pragma mark - AdvertisementViewDelegate

//倒计时结束、点击跳过，广告停止显示
- (void)advertisementViewStopView:(AdvertisementView*)advertisementView{
    [advertisementView invalid];
    self.advertisementView = nil;
    [AdvertisementManager invalid];
}
//用户点击广告，查看详情页面
- (void)advertisementView:(AdvertisementView*)advertisementView jumpToDetail:(AdvertisementModel*)advertisementModel{
 
    NSURL *url = [NSURL URLWithString:advertisementModel.clickUrl];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

+ (void)invalid{  //是否广告资源
    advertisementManager = nil;
}

@end

@implementation AdvertisementModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
