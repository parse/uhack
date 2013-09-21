//
//  ViewController.h
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"


@interface ViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet FUIButton *submitButton;
@property (nonatomic, retain) IBOutlet UITextField *fromTextView;
@property (nonatomic, retain) IBOutlet UITextField *toTextView;
@property (nonatomic, retain) IBOutlet UITableView *searchResults;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
