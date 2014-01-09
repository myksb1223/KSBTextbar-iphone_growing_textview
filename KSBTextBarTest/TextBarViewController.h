//
//  TextBarViewController.h
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSBTextbar.h"

@interface TextBarViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    KSBTextbar *textBar;
    UITableView *textList;
    NSMutableArray *textArray;
}

@property (nonatomic, retain) KSBTextbar *textBar;
@property (nonatomic, retain) UITableView *textList;
@property (nonatomic, retain) NSMutableArray *textArray;

@end
