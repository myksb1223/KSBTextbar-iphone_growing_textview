//
//  TextBarViewController.m
//  KSBTextBarTest
//
//  Created by Seungbeom Kim on 13. 10. 7..
//  Copyright (c) 2013년 Seungbeom Kim. All rights reserved.
//

#import "TextBarViewController.h"

#define margin 5
#define cellWidth 296
#define limit 9999
#define barHeight 48
#define lMargin 12
#define fontSize 15
#define keyboardHeight 216

@interface TextBarViewController ()

@end

@implementation TextBarViewController

@synthesize textBar;
@synthesize textList;
@synthesize textArray;

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
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upBtnPressed:)
                                                 name:@"upBtnPressed" object:nil];
    
    textArray = [[NSMutableArray alloc] init];
    
    textList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-barHeight) style:UITableViewStylePlain];
    textList.delegate = self;
    textList.dataSource = self;
    textList.separatorStyle = UITableViewCellSeparatorStyleNone;
    textList.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    textList.backgroundColor = [UIColor grayColor];
    [self.view addSubview:textList];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [textList addGestureRecognizer:gesture];
    [gesture release];
    
    textBar = [[KSBTextbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-barHeight, self.view.frame.size.width, barHeight)];
//    textBar.tintColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    textBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:textBar];
    
}

- (void)upBtnPressed:(id)sender {
    if(textBar.tv.text.length == 0) {
        return;
    }
    
    [textArray addObject:textBar.tv.text];
    
    [textBar makeDefaultState];
    
    [textList reloadData];
}

- (void)hideKeyboard:(id)sender {
    [textBar.tv resignFirstResponder];
    
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    gesture.cancelsTouchesInView = NO;
}

- (void)keyboardWillShow:(NSNotification *)notif {
    [UITableView beginAnimations:@"animateMoveToolbar" context:NULL];
    [UITableView setAnimationDuration:0.4];
    [self.textList setFrame:CGRectMake(textList.frame.origin.x, textList.frame.origin.y, textList.frame.size.width, textList.frame.size.height-keyboardHeight)];
    [self.textBar setFrame:CGRectOffset([self.textBar frame], 0, -keyboardHeight)];
    [UITableView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    [UITableView beginAnimations:@"animateMoveToolbar" context:NULL];
    [UITableView setAnimationDuration:0.25];
    [self.textList setFrame:CGRectMake(textList.frame.origin.x, textList.frame.origin.y, textList.frame.size.width, textList.frame.size.height+keyboardHeight)];
    [self.textBar setFrame:CGRectOffset([self.textBar frame], 0, keyboardHeight)];
    [UITableView commitAnimations];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [textArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [textArray objectAtIndex:[indexPath row]];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(cellWidth, limit) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height + (margin * 2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextBar"];
    
    UILabel *textLbl = nil;
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextBar"] autorelease];
        
        textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        textLbl.backgroundColor = [UIColor clearColor];
        textLbl.font = [UIFont systemFontOfSize:fontSize];
        textLbl.numberOfLines = 0;
        textLbl.lineBreakMode = NSLineBreakByWordWrapping;
        textLbl.tag = 1;
        [cell.contentView addSubview:textLbl];
        [textLbl release];
    }
    else {
        textLbl = (UILabel *)[cell.contentView viewWithTag:1];
        textLbl.frame = CGRectZero;
    }
    
    NSString *text = [textArray objectAtIndex:[indexPath row]];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(cellWidth, limit) lineBreakMode:NSLineBreakByWordWrapping];

    textLbl.frame = CGRectMake(lMargin, margin, cellWidth, size.height);
    textLbl.text = text;
    
    return cell;
}

- (void)viewDidUnload {
    self.textList = nil;
    self.textBar = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [textList release];
    [textBar release];
    [super dealloc];
}

@end
