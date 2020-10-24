//
//  WebViewController.m
//  NIM
//
//  Created by TURUI on 2017/6/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic,strong) IBOutlet UILabel *errorLabel;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     
     支持http访问个性以下内容:
     1.在Info.plist右键,以源码方式打开
     2.在第一个<key>之前加入以下代码:
     <key>NSAppTransportSecurity</key>
     <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
     </dict>
     
     */

    self.navigationItem.title = self.myTitle;
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsAirPlayForMediaPlayback = YES;
    config.allowsInlineMediaPlayback = YES;
    config.selectionGranularity = YES;
    _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.myUrl]]];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 2)];
    
    _errorLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    _errorLabel.text = @"加载失败，再试试吧!";
    _errorLabel.backgroundColor = [UIColor whiteColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.hidden = YES;
    
    [self.view addSubview:_wkWebView];
    [self.view addSubview:_progressView];
    [self.view addSubview:_errorLabel];
    
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - WKNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.navigationItem.title = self.wkWebView.title;
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
//    self.navigationItem.title = @"加载失败";
//    _wkWebView.hidden = YES;
    _errorLabel.hidden = NO;
    
}

#pragma mark - WKUIDelegate
//WebView关闭
- (void)webViewDidClose:(WKWebView *)webView{
    
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == _wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if (self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finish){
                [self.progressView setProgress:0.0f animated:YES];
            }];
            
        }
    }
}

- (void)dealloc{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];
}

@end
