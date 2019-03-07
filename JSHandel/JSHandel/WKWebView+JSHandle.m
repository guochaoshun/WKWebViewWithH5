//
//  WKWebView+JSHandle.m
//  JSHandel
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "WKWebView+JSHandle.h"
#import <objc/runtime.h>

@implementation WKWebView (JSHandle)


- (void)setJsHandle:(JSHandle *)jsHandle {
    objc_setAssociatedObject(self, @"jsHandle", jsHandle, OBJC_ASSOCIATION_RETAIN);
    if (jsHandle.wkWebView == nil ) {
        jsHandle.wkWebView = self ;
    }
}
- (JSHandle *)jsHandle {
    JSHandle * jsHandle = objc_getAssociatedObject(self, @"jsHandle");
    if (jsHandle == nil) {
        jsHandle = [[JSHandle alloc] initWithWKWebView:self];
        [self setJsHandle:jsHandle];
    }
    return jsHandle;
}



@end
