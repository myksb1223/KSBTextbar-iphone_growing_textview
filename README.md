KSBTextbar
==========

Growing UITextView In UIToolbar like SMS.

Usage
==========

1. Copy KSBTextbar.h, KSBTextbar.m to your project.

"`
#define barHeight 48;

//...

KSBTextbar *textBar = [[KSBTextbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-barHeight, self.view.frame.size.width, barHeight)];
textBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
//    [textBar setMaxLine:4];
[self.view addSubview:textBar];

`"
