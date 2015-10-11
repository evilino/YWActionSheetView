//
//  YWActionSheet.h
//  YWActionSheetView
//
//  Created by 张洋威 on 15/9/15.
//  Copyright (c) 2015年 YangWei Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#if !defined(YW_REQUIRES_NIL_TERMINATION)
#if TARGET_OS_WIN32
#define YW_REQUIRES_NIL_TERMINATION
#else
#if defined(__APPLE_CC__) && (__APPLE_CC__ >= 5549)
#define YW_REQUIRES_NIL_TERMINATION __attribute__((sentinel(0,1)))
#else
#define YW_REQUIRES_NIL_TERMINATION __attribute__((sentinel))
#endif
#endif
#endif

@class YWActionSheet;
@protocol YWActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(YWActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)actionSheetCancel:(YWActionSheet *)actionSheet;

@end

@interface YWActionSheet : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) id<YWActionSheetDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...YW_REQUIRES_NIL_TERMINATION;

- (void)show;

@end
