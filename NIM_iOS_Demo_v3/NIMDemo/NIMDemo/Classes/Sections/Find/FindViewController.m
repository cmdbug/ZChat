//
//  FindViewController.m
//  WZTENG
//
//  Created by WZTENG on 17/6/7.
//  Copyright (c) 2017年 WZTENG. All rights reserved.
//

#import "FindViewController.h"
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

#import "WebViewController.h"

@interface FindViewController ()<UINavigationControllerDelegate>

//@interface FindViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,NIMUserManagerDelegate>

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy)   NSArray *data;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发现";
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
    NSArray *data = @[
                      
                      @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"朋友圏",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_friends",
                                    },
                                  ],
//                          FooterTitle:@"",
                        },
                      @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"扫一扫",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_scan",
                                      },
                                  @{
                                      Title:@"摇一摇",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_shake",
                                  },
                                ],
                          },
                    @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"附近的人",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_nearby",
                                      },
                                  @{
                                      Title:@"漂流瓶",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_bottle",
                                    },
                                  ],
                          },
                    @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"购物",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_shopping",
                                      CellAction:@"onActionTouchShopping:",
                                      },
                                  @{
                                      Title:@"游戏",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_game",
                                      CellAction:@"onActionTouchGames:",
                                      },
                                  ],
                        },
                      @{
                          HeaderTitle:@"",
                          RowContent:@[
                                  @{
                                      Title:@"小程序",
                                      RowHeight:@(50),
                                      ShowAccessory:@(YES),
                                      RowIcon:@"find_programs",
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
 *购物
 */
- (void)onActionTouchShopping:(id)sender{
    WebViewController *vc = [[WebViewController alloc] initWithNibName:nil bundle:nil];
    vc.myUrl  = @"https://www.tmall.com";
    vc.myTitle = @"购物";
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *游戏
 */
- (void)onActionTouchGames:(id)sender{
    WebViewController *vc = [[WebViewController alloc] initWithNibName:nil bundle:nil];
    vc.myUrl  = @"https://www.baidu.com";
    vc.myTitle = @"游戏";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

@end
