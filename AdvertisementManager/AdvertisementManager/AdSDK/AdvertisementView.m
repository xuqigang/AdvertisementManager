//
//  AdvertisementView.m
//  WangHuo
//
//  Created by 韩肖杰 on 2018/12/5.
//  Copyright © 2018 ifeng. All rights reserved.
//

#import "AdvertisementView.h"
#import "AdvertisementManager.h"
#define AdStatusBarHeight 20
@interface AdvertisementView ()
{
    NSInteger _currentTime;
}
@property (weak, nonatomic) IBOutlet UILabel *jumpLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jumpTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation AdvertisementView
+ (instancetype)defaultView{
    AdvertisementView *view = [[NSBundle mainBundle] loadNibNamed:@"AdvertisementView" owner:nil options:nil].firstObject;
    view.frame = UIScreen.mainScreen.bounds;
    view.windowLevel = UIWindowLevelAlert + 1;
    return view;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    UIViewController *vc = [UIViewController new];
    self.rootViewController = vc;
    self.rootViewController.view.userInteractionEnabled = NO;
    self.jumpTopConstraint.constant = AdStatusBarHeight;
}

- (void)setAdvertisementData:(AdvertisementModel *)advertisementData{
    _advertisementData = advertisementData;
    self.hidden = NO;
//    [self.showImageView sd_setImageWithURL:[NSURL URLWithString:advertisementData.showUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        [weakSelf startTimer];
//    }];
    self.showImageView.image = [UIImage imageNamed:_advertisementData.adImage];
    [self startTimer];
}
- (void)startTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _currentTime = self.advertisementData.showTime;
    self.jumpLabel.text = [NSString stringWithFormat:@"跳过%lds",_currentTime];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTimeCount:) userInfo:nil repeats:YES];
}
- (void)showTimeCount:(NSTimer*)timer{
    _currentTime --;
    self.jumpLabel.text = [NSString stringWithFormat:@"跳过%lds",_currentTime];
    if (_currentTime < 0) {
        [self stopTimer];
        if (self.delegate && [self.delegate respondsToSelector:@selector(advertisementViewStopView:)]) {
            [self.delegate advertisementViewStopView:self];
        }
    }
}
- (IBAction)jumpButtonClicked:(UIButton *)sender {
    [self stopTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(advertisementViewStopView:)]) {
        [self.delegate advertisementViewStopView:self];
    }
}
- (IBAction)detailViewClicked:(UITapGestureRecognizer *)sender {
    [self stopTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(advertisementView:jumpToDetail:)]){
        [self.delegate advertisementView:self jumpToDetail:self.advertisementData];
    }
}
- (void)stopTimer{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)invalid{
    [self stopTimer];
    self.hidden = YES;
    self.rootViewController = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    } else {
        return view;
    }
}
@end
