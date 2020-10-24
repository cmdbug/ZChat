//
//  QrCodeView.m
//  NIM
//
//  Created by WZTENG on 2017/6/16.
//  Copyright © 2017年 WZTENG. All rights reserved.
//

#import "QrCodeView.h"
#import "NIMAvatarImageView.h"

#import "NIMKitInfo.h"


///alertView  宽
#define AlertW 280
///各个栏目之间的距离
#define XLSpace 10.0

@interface QrCodeView()

//弹窗
@property (nonatomic,retain) UIView *alertView;

//wzteng
//关闭图标
@property (nonatomic,retain) UIImageView *closeImage;
//头像
@property (nonatomic,retain) NIMAvatarImageView *avatar;
//名称
@property (nonatomic,retain) UILabel *userName;
//二维码
@property (nonatomic,retain) UIImageView *qrCodeImage;
//底部文本
@property (nonatomic,retain) UILabel *tip;


@end

@implementation QrCodeView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle{
    if (self == [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 5.0;
        self.alertView.frame = CGRectMake(0, 0, AlertW, 200);
        self.alertView.layer.position = self.center;
        
        //wzteng
        self.closeImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 25, 25)];
        self.closeImage.image = [UIImage imageNamed:@"btn_cross"];
        [self.alertView addSubview:self.closeImage];
        self.closeImage.userInteractionEnabled = YES;//响应触摸事件，否则不会响应
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouchCloseImage)];
        [self.closeImage addGestureRecognizer:singleTap];
        
        NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
        NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:uid option:nil];
        self.avatar = [[NIMAvatarImageView alloc] initWithFrame:CGRectMake(35, 35, 60, 60)];
        [self.alertView addSubview:self.avatar];
        [self.avatar nim_setImageWithURL:[NSURL URLWithString:info.avatarUrlString] placeholderImage:info.avatarImage options:SDWebImageRetryFailed];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, 100, 20)];
        self.userName.text  = info.showName;
        [self.alertView addSubview:self.userName];
        
        self.qrCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake((AlertW - 200) / 2, 120, 200, 200)];
        self.qrCodeImage.image = [UIImage imageNamed:@"1"];
        [self.alertView addSubview:self.qrCodeImage];
        
        self.tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 360, AlertW, 20)];
        self.tip.textAlignment = NSTextAlignmentCenter;
        self.tip.text = @"扫一扫上面的二维码，加我藤信";
        self.tip.font = [UIFont systemFontOfSize:15.f];
        self.tip.textColor = [UIColor grayColor];
        [self.alertView addSubview:self.tip];
        
        self.alertView.frame = CGRectMake(0, 0, AlertW, 400);
        self.alertView.layer.position = self.center;
        [self addSubview:self.alertView];
    }
    return self;
}

#pragma mark - 弹出 -
- (void)showXLAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

- (void)creatShowAnimation
{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}

//wzteng
/**
 *关闭按钮
 */
- (void)onTouchCloseImage
{
    [self removeFromSuperview];
}


@end
