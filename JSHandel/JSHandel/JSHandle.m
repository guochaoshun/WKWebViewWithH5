//
//  JSHandle.m
//  JSHandel
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "JSHandle.h"
#import <WebKit/WebKit.h>
#import "WKWebView+JSHandle.h"

@interface JSHandle ()<WKScriptMessageHandler>

@property(nonatomic,strong) NSMutableDictionary * dataSouse ;


@end


@implementation JSHandle

- (instancetype)initWithWKWebView:(WKWebView *)webView
{
    self = [super init];
    if (self) {
        _dataSouse = [[NSMutableDictionary alloc] init];
        _wkWebView = webView;
        _wkWebView.jsHandle = self;
    }
    return self;
}
- (void)setWkWebView:(WKWebView *)wkWebView {
    _wkWebView = wkWebView;
    if (_wkWebView.jsHandle == nil) {
        _wkWebView.jsHandle = self;
    }
}

- (void)addScriptName:(NSString *)name messageHandler:(JSHandleBlock)block {
    self.dataSouse[name] = [block copy];
    
     WKUserContentController * userContent = self.wkWebView.configuration.userContentController;
    [userContent addScriptMessageHandler:self name:name];
    
}
- (void)removeScriptName:(NSString *)name {
    self.dataSouse[name] = nil;
    WKUserContentController * userContent = self.wkWebView.configuration.userContentController;
    [userContent removeScriptMessageHandlerForName:name];
}

- (void)removeAllScriptName {
    
    WKUserContentController * userContent = self.wkWebView.configuration.userContentController;
    for (NSString * key in self.dataSouse) {
        [userContent removeScriptMessageHandlerForName:key];
    }
    [self.dataSouse removeAllObjects];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"JSHandle中 方法 : %@ 参数 : %@",message.name,message.body);
    if (self.dataSouse[message.name]) {
        JSHandleBlock block = self.dataSouse[message.name];
        block(message.body);
    }
    
}


- (void)dealloc {
    NSLog(@"%@ dealloc",self);
}









@end
