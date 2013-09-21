//
//  ViewController.h
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "FUISwitch.h"
#import "FUIAlertView.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, FUIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet FUIButton *submitButton;
@property (nonatomic, retain) IBOutlet UITextField *fromTextView;
@property (nonatomic, retain) IBOutlet UITextField *toTextView;
@property (nonatomic, retain) IBOutlet UITableView *searchResults;
@property (nonatomic, retain) IBOutlet UIView *logoView;
@property (nonatomic, retain) IBOutlet UILabel *priceIndicator;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
