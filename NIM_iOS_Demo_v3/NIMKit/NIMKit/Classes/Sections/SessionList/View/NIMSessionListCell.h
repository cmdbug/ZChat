//
//  NTESSessionListCell.h
//  NIMDemo
//
//  Created by chris on 15/2/10.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NIMAvatarImageView;
@class NIMRecentSession;
@class NIMBadgeView;

@interface NIMSessionListCell : UITableViewCell

@property (nonatomic,strong) NIMAvatarImageView *avatarImageView;//头像

@property (nonatomic,strong) UILabel *nameLabel;//名称

@property (nonatomic,strong) UILabel *messageLabel;//内容

@property (nonatomic,strong) UILabel *timeLabel;//时间

@property (nonatomic,strong) NIMBadgeView *badgeView;//角标

- (void)refresh:(NIMRecentSession*)recent;

@end
