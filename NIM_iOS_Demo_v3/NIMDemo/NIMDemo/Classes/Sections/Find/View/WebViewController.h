//
//  WebViewController.h
//  NIM
//
//  Created by TURUI on 2017/6/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic,strong) IBOutlet WKWebView *wkWebView;
@property (nonatomic,strong) IBOutlet UIProgressView *progressView;
@property (nonatomic,copy) IBOutlet NSString *myUrl;
@property (nonatomic,copy) IBOutlet NSString *myTitle;

@end
