//
//  NIMSessionListViewController.m
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMSessionListViewController.h"
#import "NIMSessionViewController.h"
#import "NIMSessionListCell.h"
#import "UIView+NIM.h"
#import "NIMAvatarImageView.h"
#import "NIMKitUtil.h"
#import "NIMKit.h"


@interface NIMSessionListViewController ()

@end

@implementation NIMSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];//初始化列表视图
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];//wzteng设置分隔线左侧为0
//    [self.tableView setLayoutMargins:UIEdgeInsetsZero];//wzteng设置分隔线左侧为0
    
    [self.view addSubview:self.tableView];//增加列表视图
    self.tableView.delegate         = self;
    self.tableView.dataSource       = self;//数据源
    self.tableView.tableFooterView  = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;//自动调整宽高保证间距不变
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    if (!self.recentSessions.count) {
        _recentSessions = [NSMutableArray array];
    }

    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    extern NSString *const NIMKitTeamInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamInfoHasUpdatedNotification:) name:NIMKitTeamInfoHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitTeamMembersHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTeamMembersHasUpdatedNotification:) name:NIMKitTeamMembersHasUpdatedNotification object:nil];
    
    extern NSString *const NIMKitUserInfoHasUpdatedNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserInfoHasUpdatedNotification:) name:NIMKitUserInfoHasUpdatedNotification object:nil];
}

- (void)refresh:(BOOL)reload{
    if (!self.recentSessions.count) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
    if (reload) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
    [self onSelectedRecent:recentSession atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NIMRecentSession *recentSession = self.recentSessions[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self onDeleteRecentAtIndexPath:recentSession atIndexPath:indexPath];
    }
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recentSessions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //静态变量降低内存消耗
    static NSString * cellId = @"cellId";
    //根据标识符取可重用的cell
    NIMSessionListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //是否可重用
    if (!cell) {
        cell = [[NIMSessionListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell.avatarImageView addTarget:self action:@selector(onTouchAvatar:) forControlEvents:UIControlEventTouchUpInside];
    }
    NIMRecentSession *recent = self.recentSessions[indexPath.row];
    cell.nameLabel.text = [self nameForRecentSession:recent];//名称
    [cell.avatarImageView setAvatarBySession:recent.session];//头像
    [cell.nameLabel sizeToFit];
    cell.messageLabel.attributedText  = [self contentForRecentSession:recent];//内容
    [cell.messageLabel sizeToFit];
    cell.timeLabel.text = [self timestampDescriptionForRecentSession:recent];//时间
    [cell.timeLabel sizeToFit];
    
    [cell refresh:recent];//刷新
    return cell;
}


#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self.recentSessions addObject:recentSession];
    [self sort];
    [self refresh:YES];
}


- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    for (NIMRecentSession *recent in self.recentSessions) {
        if ([recentSession.session.sessionId isEqualToString:recent.session.sessionId]) {
            [self.recentSessions removeObject:recent];
            break;
        }
    }
    NSInteger insert = [self findInsertPlace:recentSession];
    [self.recentSessions insertObject:recentSession atIndex:insert];
    [self refresh:YES];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount
{
    //清理本地数据
    NSInteger index = [self.recentSessions indexOfObject:recentSession];
    [self.recentSessions removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    if (self.autoRemoveRemoteSession)
    {
        [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                           completion:nil];
    }
    
    [self refresh:NO];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self refresh:YES];
}

- (void)allMessagesDeleted{
    _recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self refresh:YES];
}


#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepSyncOK) {
        [self refresh:YES];
    }
}

#pragma mark - Override
- (void)onSelectedAvatar:(NSString *)userId
             atIndexPath:(NSIndexPath *)indexPath{};

- (void)onSelectedRecent:(NIMRecentSession *)recentSession atIndexPath:(NSIndexPath *)indexPath{
    NIMSessionViewController *vc = [[NIMSessionViewController alloc] initWithSession:recentSession.session];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath{
    id<NIMConversationManager> manager = [[NIMSDK sharedSDK] conversationManager];
    [manager deleteRecentSession:recent];
}


- (NSString *)nameForRecentSession:(NIMRecentSession *)recent{
    if (recent.session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:recent.session.sessionId inSession:recent.session];
    }else{
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:recent.session.sessionId];
        return team.teamName;
    }
}

- (NSAttributedString *)contentForRecentSession:(NIMRecentSession *)recent{
    NSString *content = [self messageContent:recent.lastMessage];
    return [[NSAttributedString alloc] initWithString:content];
}

- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent{
    return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
}

#pragma mark - Misc

- (NSInteger)findInsertPlace:(NIMRecentSession *)recentSession{
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    }else{
        return self.recentSessions.count;
    }
}

- (void)sort{
    [self.recentSessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NIMRecentSession *item1 = obj1;
        NIMRecentSession *item2 = obj2;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp) {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (void)onTouchAvatar:(id)sender{
    UIView *view = [sender superview];
    while (![view isKindOfClass:[UITableViewCell class]]) {
        view = view.superview;
    }
    UITableViewCell *cell  = (UITableViewCell *)view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NIMRecentSession *recent = self.recentSessions[indexPath.row];
    [self onSelectedAvatar:recent atIndexPath:indexPath];
}



#pragma mark - Private
- (NSString *)messageContent:(NIMMessage*)lastMessage{
    NSString *text = @"";
    switch (lastMessage.messageType) {
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
        case NIMMessageTypeLocation:
            text = @"[位置]";
            break;
        case NIMMessageTypeNotification:{
            return [self notificationMessageContent:lastMessage];
        }
        case NIMMessageTypeFile:
            text = @"[文件]";
            break;
        case NIMMessageTypeTip:
            text = lastMessage.text;
            break;
        default:
            text = @"[未知消息]";
    }
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip) {
        return text;
    }else{
        NSString *nickName = [NIMKitUtil showNick:lastMessage.from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

- (NSString *)notificationMessageContent:(NIMMessage *)lastMessage{
    NIMNotificationObject *object = lastMessage.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        if (content.callType == NIMNetCallTypeAudio) {
            return @"[网络通话]";
        }
        return @"[视频聊天]";
    }
    if (object.notificationType == NIMNotificationTypeTeam) {
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:lastMessage.session.sessionId];
        if (team.type == NIMTeamTypeNormal) {
            return @"[讨论组信息更新]";
        }else{
            return @"[群信息更新]";
        }
    }
    return @"[未知消息]";
}

#pragma mark - Notification
- (void)onUserInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh:YES];
}

- (void)onTeamInfoHasUpdatedNotification:(NSNotification *)notification{
    [self refresh:YES];
}

- (void)onTeamMembersHasUpdatedNotification:(NSNotification *)notification{
    [self refresh:YES];
}



@end
