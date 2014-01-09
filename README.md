KSBTextbar
==========

Growing UITextView In UIToolbar like SMS.

Usage
==========

1. Copy KSBTextbar.h, KSBTextbar.m to your project.
2. Create the object in viewDidUnload method.

```
#define barHeight 48;

- (void)viewDidUnLoad {

//...

  KSBTextbar *textBar = [[KSBTextbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-barHeight, self.view.frame.size.width, barHeight)];
  textBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
  //    [textBar setMaxLine:4];
  [self.view addSubview:textBar];
}
```
* KSBTextbar has already button action. So you have to register notification in your controller.

```

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upBtnPressed:)
                                                 name:@"upBtnPressed" object:nil];
                                                 
  //...                                                 
}

- (void)upBtnPressed:(id)sender {
  //... do something
}
                                                 
- (void)dealloc {
  [NSNotificationCenter defaultCenter] removeObserver:self];
  [super dealloc];
}
```

* If textview in the KSBTextbar object has focus, keyboard will show. Otherwise, keyboard will hide. 
   So you have to change the KSBTextBar object's offset. Please register notification related with UIKeyboard.

```

#define keyboardHeight 216

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
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
  
```

Thanks.
