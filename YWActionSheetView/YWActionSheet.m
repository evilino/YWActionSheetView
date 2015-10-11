//
//  YWActionSheet.m
//  YWActionSheetView
//
//  Created by 张洋威 on 15/9/15.
//  Copyright (c) 2015年 YangWei Zhang. All rights reserved.
//

#import "YWActionSheet.h"

#define ywButtonTitleFontSize 14
#define ywTitleFontSize 10
#define ywButtonHeight 40
#define ywRowLineHeight .7
#define ywSectionLineHeigth 7
#define ywTitleMarginHeight 20

#define ywScreenWidth [UIScreen mainScreen].bounds.size.width
#define ywScreenHeight [UIScreen mainScreen].bounds.size.height
#define ywKeyWindow [UIApplication sharedApplication].keyWindow

@implementation YWActionSheet
{
    UILabel *titleLabel;
    UIButton *cancelButton;
    UIButton *destructiveButton;
    NSMutableArray *otherButtonsArray;
    UIView *markView;
    
    BOOL isLoaded;
}

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
        NSMutableArray *otherButtonTitlesArray = [NSMutableArray arrayWithCapacity:0];
        otherButtonsArray = [NSMutableArray arrayWithCapacity:0];
      
        va_list otherTitles;
        va_start(otherTitles,otherButtonTitles);
        NSString *otherTitle;
        if (otherButtonTitles) {
            while((otherTitle = va_arg(otherTitles,NSString *))) {
                [otherButtonTitlesArray addObject:otherTitle];
            }
        }
        va_end(otherTitles);
        
        if (title) {
            _title = title;
            [self loadTitleLabel];
        }
        
        [self loadMarkView];
        [self loadCancelButtonWithTitle:cancelButtonTitle];
        [self loadDestructiveButtonWithTitle:destructiveButtonTitle];
        [self loadOtherButtonsWithTitlesArray:otherButtonTitlesArray];
        [self handleFrame];
    }
    return self;
}

- (instancetype)init
{
   return [self initWithTitle:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithTitle:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
}


- (void)loadTitleLabel
{
    if (!titleLabel) {
        titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:ywTitleFontSize];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 3;
        if (_title) {
            titleLabel.text = _title;
        }
        [self addSubview:titleLabel];
    }
}

- (void)loadCancelButtonWithTitle:(NSString *)title
{
    if (!cancelButton) {
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor whiteColor];
        if (title) {
            [cancelButton setTitle:title forState:UIControlStateNormal];
        } else {
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        }
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:ywButtonTitleFontSize];
        [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
}

- (void)loadDestructiveButtonWithTitle:(NSString *)title
{
    if (!destructiveButton) {
        destructiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        destructiveButton.backgroundColor = [UIColor whiteColor];
        if (title) {
            [destructiveButton setTitle:title forState:UIControlStateNormal];
        } else {
            [destructiveButton setTitle:@"确定" forState:UIControlStateNormal];
        }
        [destructiveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        destructiveButton.titleLabel.font = [UIFont systemFontOfSize:ywButtonTitleFontSize];
        [destructiveButton addTarget:self action:@selector(destructiveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:destructiveButton];
    }
}

- (void)loadOtherButtonsWithTitlesArray:(NSArray *)array
{
    for (NSString *title in array) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:ywButtonTitleFontSize];
        [button addTarget:self action:@selector(otherButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [otherButtonsArray addObject:button];
    }
}

- (void)loadMarkView
{
    if (!markView) {
        markView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ywScreenWidth, ywScreenHeight)];
        markView.backgroundColor = [UIColor colorWithWhite:.5 alpha:0];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMarkViewTapGesture:)];
        [markView addGestureRecognizer:tapGesture];
    }
}

#pragma mark - set
- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
    }
    
    [self loadTitleLabel];
    [self handleFrame];
}


#pragma mark - Action Methods
- (void)handleMarkViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [self dismiss];
}

- (void)cancelButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:0];
    }
    if ([_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self dismiss];
}

- (void)destructiveButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:1];
    }
    [self dismiss];
}

- (void)otherButtonAction:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        for (int i = 0; i < otherButtonsArray.count; i++) {
            if (otherButtonsArray[i] == button) {
                
                [_delegate actionSheet:self clickedButtonAtIndex:i+2];
                break;
            }
        }
    }
    [self dismiss];
}

#pragma mark -
- (void)handleFrame
{
    self.frame = CGRectMake(0, ywScreenHeight, ywScreenWidth, 0);
    CGFloat firstOtherButtonY = 0;
    CGFloat lastOtherButtonBottom = 0;
    if (titleLabel) {
        CGRect rect = [titleLabel.text
                       boundingRectWithSize:CGSizeMake(1000, 1000)
                       options:NSStringDrawingTruncatesLastVisibleLine
                       attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:ywTitleFontSize]}
                       context:nil];
        titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, rect.size.height + ywTitleMarginHeight * 2);
        firstOtherButtonY = titleLabel.frame.size.height + titleLabel.frame.origin.y;
        lastOtherButtonBottom = firstOtherButtonY;
    }
    
    for (NSInteger i = otherButtonsArray.count-1; i >= 0; i--) {
        UIButton *button = otherButtonsArray[i];
        button.frame = CGRectMake(0, firstOtherButtonY + ywButtonHeight * (otherButtonsArray.count - 1 - i) + ywRowLineHeight, self.bounds.size.width, ywButtonHeight);
        lastOtherButtonBottom = button.frame.origin.y + ywButtonHeight;
    }
    destructiveButton.frame = CGRectMake(0, lastOtherButtonBottom + ywRowLineHeight, self.bounds.size.width, ywButtonHeight);
    
    cancelButton.frame = CGRectMake(0, destructiveButton.frame.origin.y + destructiveButton.bounds.size.height + ywSectionLineHeigth, self.bounds.size.width, ywButtonHeight);
    self.frame = CGRectMake(0, ywScreenHeight, ywScreenWidth, cancelButton.frame.origin.y + cancelButton.bounds.size.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}


#pragma mark - Public Methods
- (void)show
{
    if (!isLoaded) {
        isLoaded = YES;

        [ywKeyWindow addSubview:self];
        [ywKeyWindow insertSubview:markView belowSubview:self];
    }
    
    [UIView animateWithDuration:.35 animations:^{
        markView.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
        self.frame = CGRectMake(0, ywScreenHeight - self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
    }];
    
}

- (void)dismiss
{
    [UIView animateWithDuration:.35 animations:^{
        self.frame = CGRectMake(0, ywScreenHeight, self.bounds.size.width, self.bounds.size.height);
        markView.alpha = 0;
    } completion:^(BOOL finished) {
        [markView removeFromSuperview];
        markView = nil;
        [self removeFromSuperview];
    }];
}


@end
