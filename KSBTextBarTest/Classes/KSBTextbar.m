//
//  KSBTextbar.m
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import "KSBTextbar.h"

#define MARGIN 12
#define FONTSIZE 15
#define GAP 20
#define INSET 8
#define LIMITHEIGHT 9999

@implementation KSBTextbar

@synthesize tv;
@synthesize backView;
@synthesize upBtn;
@synthesize minHeight, defaultY;
@synthesize maxLine, num;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        maxLine = 3;
        defaultY = frame.origin.y;
        
        UIImage *upImage = [UIImage imageNamed:@"upbutton_inputbox.png"];
        
        upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        upBtn.frame = CGRectMake(0, 0, upImage.size.width, upImage.size.height);
        [upBtn addTarget:self action:@selector(upBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [upBtn setImage:upImage forState:UIControlStateNormal];
        
        UIBarButtonItem *upItem = [[UIBarButtonItem alloc] initWithCustomView:upBtn];
        [upBtn retain];
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-(MARGIN*3)-upImage.size.width, frame.size.height-MARGIN)];
        tv = [[UITextView alloc] initWithFrame:CGRectMake(0, 8, frame.size.width-(MARGIN*3)-upImage.size.width, GAP)];
        tv.delegate = self;
        tv.font = [UIFont systemFontOfSize:FONTSIZE];
        [tv setContentInset:UIEdgeInsetsMake(-INSET, 0, -INSET, 0)];

        
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

- (void)makeDefaultState {
    backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, minHeight);
    tv.frame = CGRectMake(tv.frame.origin.x, tv.frame.origin.y, tv.frame.size.width, GAP);
    self.frame = CGRectMake(self.frame.origin.x, defaultY, self.frame.size.width, minHeight+MARGIN);
    num = 0;
    tv.text = @"";
}

- (void)setMaxLine:(int)aMaxLine {
    self.maxLine = aMaxLine;
}

- (void)upBtnPressed:(id)sender {
    // Send notification to your controller
    [[NSNotificationCenter defaultCenter] postNotificationName:@"upBtnPressed" object:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if(num > 1) {
        defaultY = self.frame.origin.y + (GAP*(num-1));
    }
    else {
        defaultY = self.frame.origin.y;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    float backSize = 0, textSize = 0, selfSize = 0, selfY;

    float height = [self measureHeightOfUITextView:textView];

    // Each letter of text in textview has different size. So I decided minumsize (GAP-4).
    // 16 = backview.frame.size.height - textview.frame.size.height
    int lineNum = (height-16) / (GAP-4);
    num = lineNum;
    
    if(lineNum > maxLine) {
        num = maxLine;
    }
    
    backSize = minHeight + (GAP*(num-1));
    textSize = GAP + (GAP*(num-1));
    selfSize = minHeight + (GAP*(num-1)) + MARGIN;
    selfY = defaultY - (GAP*(num-1));
    
    backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, backView.frame.size.width, backSize);
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, textSize);
    self.frame = CGRectMake(self.frame.origin.x, selfY, self.frame.size.width, selfSize);
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [textView setContentOffset:CGPointZero animated:NO];
        [textView setContentOffset:CGPointMake(0, height-textSize-8) animated:NO];
    }
    else {
        CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
        CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height -1, 0);
        if(textView.contentOffset.y < caretY && r.origin.y != INFINITY)
            textView.contentOffset = CGPointMake(0, MIN(caretY, textView.contentSize.height));
    }
}

// I got this method from http://stackoverflow.com/questions/19046969/uitextview-content-size-different-in-ios7
- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight + 16;
    }
    else
    {
        CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, LIMITHEIGHT)];
        return size.height;
    }
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
