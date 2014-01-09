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
    float minHeight, defaultY;
    int maxLine, num;
}

@property (nonatomic, retain) UITextView *tv;
@property (nonatomic, retain) UIView *backView;
@property (nonatomic, retain) UIButton *upBtn;
@property (nonatomic, assign) float minHeight, defaultY;
@property (nonatomic, assign) int maxLine, num;

/*
 This method is make KSBTextbar object init.
 This is called after user pressed the 'up' button.
*/

- (void)makeDefaultState;

@end
