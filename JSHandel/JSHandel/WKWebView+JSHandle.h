//
//  WKWebView+JSHandle.h
//  JSHandel
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "JSHandle.h"
NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (JSHandle)

@property(nonatomic,strong) JSHandle * jsHandle ;

@end

NS_ASSUME_NONNULL_END
