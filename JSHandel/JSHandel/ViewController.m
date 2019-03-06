//
//  ViewController.m
//  JSHandel
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "JSHandle.h"

@interface ViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property(nonatomic,strong) WKWebView * webView ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView reload];
    

    
}

- (IBAction)iOSToH5Action:(id)sender {
    
    NSString *jsFounction = [NSString stringWithFormat:@"iosToH5('%@')", @"原生调h5"];
    [self.webView evaluateJavaScript:jsFounction completionHandler:^(id object, NSError * _Nullable error) {
        NSLog(@"obj:%@---error:%@", object, error);
    }];

    
}
- (IBAction)toNewViewController:(id)sender {
    
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - WebView代理方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"H5调原生 方法 : %@ 参数 : %@",message.name,message.body);
    
    
    
}




- (WKWebView *)webView {
    if (_webView == nil) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"lll"];
        
        
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:config];
        // JSHandle的方式可以与原生的方式共存,并且无冲突
        JSHandle * handel = [[JSHandle alloc]initWithWKWebView:_webView];
        [handel addScriptName:@"showMessage" messageHandler:^(id  _Nonnull dataFormH5) {
            NSLog(@"%@",self);
            NSLog(@"block回调中 %@",dataFormH5);
        }];
        // 同一个name,不可以重复添加到userContentController中
//        [handel addScriptName:@"lll" messageHandler:^(id  _Nonnull dataFormH5) {
//            NSLog(@"%@",dataFormH5);
//        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [config.userContentController removeScriptMessageHandlerForName:@"lll"];
            [handel removeAllScriptName];
        });
        
        
        NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"html" ofType:@"htm"];
        NSURL * url = [NSURL fileURLWithPath: htmlPath];
        [_webView  loadRequest:[NSURLRequest requestWithURL:url]];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        
//        [self.view addSubview:_webView];
        [self.view insertSubview:_webView atIndex:0];
        
    }
    return _webView;
}


// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%@ dealloc",self);
}

@end
