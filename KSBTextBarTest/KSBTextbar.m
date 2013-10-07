//
//  KSBTextbar.m
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import "KSBTextbar.h"

#define margin 12
#define fontSize 15
#define gap 18

@implementation KSBTextbar

@synthesize tv;
@synthesize backView;
@synthesize upBtn;
@synthesize isNewLine;
@synthesize gapHeight, minHeight, defaultY;
@synthesize count, returnTotal;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isNewLine = NO;
        gapHeight = 0;
        returnTotal = 0;
        count = 1;
        
        UIImage *upImage = [UIImage imageNamed:@"upbutton_inputbox.png"];
        
        upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upBtn.frame = CGRectMake(0, 0, upImage.size.width, upImage.size.height);
        [upBtn setImage:upImage forState:UIControlStateNormal];
        
        UIBarButtonItem *upItem = [[UIBarButtonItem alloc] initWithCustomView:upBtn];
        [upBtn retain];
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-(margin*3)-upImage.size.width, frame.size.height-(margin/2))];
        tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 8, frame.size.width-(margin*3)-upImage.size.width, gap)];
        tv.delegate = self;
        tv.font = [UIFont systemFontOfSize:fontSize];
        [tv setContentInset:UIEdgeInsetsMake(-8, 0, -8, 0)];
        
        minHeight = backView.frame.size.height;
        
        backView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:tv];
        UIBarButtonItem *textItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
        
        [self setItems:[NSArray arrayWithObjects:textItem, upItem, nil]];
        [textItem release];
        [upItem release];
    }
    return self;
}

- (void) goToBottom
{
    NSUInteger length = self.tv.text.length;
    self.tv.selectedRange = NSMakeRange(length, 0);
    
    [tv setContentOffset:CGPointMake(length, 0) animated:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    defaultY = self.frame.origin.y;
}

- (void)textViewDidChange:(UITextView *)textView {
    if(!textView.hasText || textView.contentSize.height <= minHeight) {
        backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, minHeight);
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, gap);
        self.frame = CGRectMake(self.frame.origin.x, defaultY, self.frame.size.width, minHeight+margin/2);
        gapHeight = 0;
        count = 1;
    }
    else {
        int result = [self countReturn];
        if(returnTotal > result) {
            returnTotal = result;
            textView.contentSize = CGSizeMake(0, textView.contentSize.height-gap);
        }
        
        float delta = textView.contentSize.height - minHeight;
        if(gapHeight < delta) {
            if(count < 3) {
                count++;
                gapHeight = delta;
                backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, textView.contentSize.height);
                textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, gap*count);
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-gap, self.frame.size.width, textView.contentSize.height+margin/2);
            }
            else {
                NSRange range = NSMakeRange(textView.text.length - 1, 1);
                [textView scrollRangeToVisible:range];
            }
        }
        else if(gapHeight > delta) {
            if(count > 1) {
                count--;
                gapHeight = delta;
                backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, textView.contentSize.height);                
                textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, gap*count);
                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+gap, self.frame.size.width, textView.contentSize.height+margin/2);
            }
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if(textView.text.length == 0) {
        backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, textView.contentSize.height);
        textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, gap);
        self.frame = CGRectMake(self.frame.origin.x, defaultY, self.frame.size.width, minHeight+margin/2);
        gapHeight = 0;
        count = 1;
    }
    
    if([text isEqualToString:@"\n"]) {
        if(count < 3) {
            textView.contentSize = CGSizeMake(0, textView.contentSize.height+gap);
        }
        else {
            textView.contentOffset = CGPointMake(0, gap*(returnTotal+1));
        }
    }
    
    returnTotal = [self countReturn];
    
    return YES;
}

- (int)countReturn {
    NSString *thestring = tv.text;
    int returnint = 0;
    
    for (int temp = 0; temp < [thestring length]; temp++){
        if ([thestring characterAtIndex: temp] == '\n')
            returnint++;
    }
    
    return returnint;
}


- (void)dealloc {
    [backView release];
    [upBtn release];
    [tv release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
                

@end
