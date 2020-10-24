//
//  ProfileViewController.m
//  WZTENG
//
//  Created by WZTENG on 17/6/7.
//  Copyright (c) 2017年 WZTENG. All rights reserved.
//

#import "ProfileViewController.h"
#import "NIMCommonTableData.h"
#import "NIMCommonTableDelegate.h"
#import "NTESNickNameSettingViewController.h"
#import "NTESGenderSettingViewController.h"
#import "NTESBirthSettingViewController.h"
#import "NTESMobileSettingViewController.h"
#import "NTESEmailSettingViewController.h"
#import "NTESSignSettingViewController.h"
#import "NTESUserUtil.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "UIActionSheet+NTESBlock.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"
#import "SDWebImageManager.h"

//wzteng
#import "NTESUserInfoSettingViewController.h"
#import "NTESSettingViewController.h"


@interface ProfileViewController ()<UINavigationControllerDelegate>

//@interface ProfileViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,NIMUserManagerDelegate>

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy)   NSArray *data;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我";
    [self buildData];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    
//    [[NIMSDK sharedSDK].userManager addDelegate:self];
}

- (void)dealloc{
//    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)buildData{
//    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSArray *data = @[
                      
                      @{
                          HeaderTitle:@"",
                          RowContent :@[
                                  @{
                                      ExtraInfo     : uid.length ? uid : [NSNull null],
                                      CellClass     : @"NTESSettingPortraitInfoCell",
                                      RowHeight     : @(100),
                                      CellAction    : @"onActionTouchPortrait:",
                                      ShowAccessory : @(YES),
                                      },
                                  ],
                          FooterTitle:@""
                          },
                      @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"相册",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"profile_photo",
                                      },
                                  @{
                                      Title:@"收藏",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"profile_collection",
                                  },
                                ],
                          },
                    @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"钱包",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"profile_money",
                                      },
                                  @{
                                      Title:@"卡包",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"profile_cardpackage",
                                    },
                                  ],
                          },
                    @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"表情",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"profile_expression",
                                      },
                                  ],
                        },
                      @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"设置",
                                      RowHeight:@(50),
                                      CellAction    : @"onActionTouchSetting:",
                                      ShowAccessory:@(YES),
                                      RowIcon:@"profile_setting",
                                      },
                                  ],
                          FooterTitle:@"",
                          },

                      ];
    self.data = [NIMCommonTableSection sectionsWithData:data];
}


- (void)refresh{
    [self buildData];
    [self.tableView reloadData];
}
/**
 *个人信息
 */
- (void)onActionTouchPortrait:(id)sender{
    NTESUserInfoSettingViewController *vc = [[NTESUserInfoSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *设置
 */
- (void)onActionTouchSetting:(id)sender{
    NTESSettingViewController *vc = [[NTESSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

@end
