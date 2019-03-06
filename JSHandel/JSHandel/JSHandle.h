//
//  JSHandle.h
//  JSHandel
//
//  Created by apple on 2019/3/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JSHandleBlock)(id dataFormH5);

@class WKWebView;
@interface JSHandle : NSObject

- (instancetype)initWithWKWebView:(WKWebView *)webView ;

- (void)addScriptName:(NSString *)name messageHandler:(JSHandleBlock)block;
- (void)removeScriptName:(NSString *)name ;
- (void)removeAllScriptName ;




@end

NS_ASSUME_NONNULL_END
