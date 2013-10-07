//
//  KSBTextbar.h
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSBTextbar : UIToolbar <UITextViewDelegate> {
    UITextView *tv;
    UIView *backView;
    UIButton *upBtn;
    BOOL isNewLine;
    float gapHeight, minHeight, defaultY;
    int count, returnTotal;
}

@property (nonatomic, retain) UITextView *tv;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIButton *upBtn;
@property (nonatomic, assign) BOOL isNewLine;
@property (nonatomic, assign) float gapHeight, minHeight, defaultY;
@property (nonatomic, assign) int count, returnTotal;

@end
