//
//  QrCodeView.h
//  NIM
//
//  Created by WZTENG on 2017/6/16.
//  Copyright © 2017年 WZTENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface QrCodeView : UIView

@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showXLAlertView;

@end
