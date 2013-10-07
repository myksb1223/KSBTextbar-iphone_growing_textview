//
//  TextBarViewController.h
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSBTextbar.h"

@interface TextBarViewController : UIViewController {
    KSBTextbar *textBar;
}

@property (nonatomic, retain) KSBTextbar *textBar;

@end
