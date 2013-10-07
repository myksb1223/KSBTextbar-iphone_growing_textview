//
//  TextBarViewController.m
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import "TextBarViewController.h"

@interface TextBarViewController ()

@end

@implementation TextBarViewController

@synthesize textBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    textBar = [[KSBTextbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40)];
    [self.view addSubview:textBar];
    
}

- (void)keyboardWillShow:(NSNotification *)notif {
    [UITableView beginAnimations:@"animateMoveToolbar" context:NULL];
    [UITableView setAnimationDuration:0.4];
    //    [self.backView setFrame:CGRectMake(0, 44, 320, self.backView.frame.size.height-216)];
    [self.textBar setFrame:CGRectOffset([self.textBar frame], 0, -216)];
    [UITableView commitAnimations];
//    toolbarOriginY = bToolbar.frame.origin.y;
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UITableView beginAnimations:@"animateMoveToolbar" context:NULL];
    [UITableView setAnimationDuration:0.25];
    //    [self.backView setFrame:CGRectMake(0, 44, 320, self.backView.frame.size.height+216)];
    [self.textBar setFrame:CGRectOffset([self.textBar frame], 0, 216)];
    [UITableView commitAnimations];
//    toolbarOriginY = bToolbar.frame.origin.y;
}


- (void)viewDidUnload {
    self.textBar = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [textBar release];
    [super dealloc];
}

@end
