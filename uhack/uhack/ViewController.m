//
//  ViewController.m
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import "ViewController.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "AppDelegate.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import  "QuartzCore/QuartzCore.h"
#import <RestKit/RestKit.h>
#import "Location.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *org_array;
    NSMutableArray *autocomplete_array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    org_array = [[NSMutableArray alloc] init];
    autocomplete_array = [[NSMutableArray alloc] init];
}

- (void)initTableView
{
    self.searchResults.layer.borderWidth = 1.0;
    self.searchResults.layer.borderColor = [[UIColor colorWithWhite:.5 alpha:.5] CGColor];
}

- (CGFloat)getTableViewHeight
{
    CGFloat height = self.searchResults.rowHeight;
    height *= 3;
    return height;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
	
    [self initTapRecognizers];
    [self initSubmitButton];
    [self initTextFields];
    [self initTableView];
}

- (void)initTextFields
{
    self.fromTextView.layer.borderWidth = 1.0;
    self.searchResults.layer.borderColor = [[UIColor colorWithWhite:.5 alpha:.5] CGColor];
    self.toTextView.layer.borderWidth = 1.0;
    self.searchResults.layer.borderColor = [[UIColor colorWithWhite:.5 alpha:.5] CGColor];
}

- (void) initTapRecognizers
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.fromTextView) {
        [self.toTextView becomeFirstResponder];
    }
    else if (textField == self.toTextView)
    {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect logoFrame = self.logoView.frame;
        self.logoView.frame = CGRectify(logoFrame, -1, logoFrame.origin.y - 100, -1, -1);
        
        CGRect fromFrame = self.fromTextView.frame;
        self.fromTextView.frame = CGRectify(fromFrame, -1, fromFrame.origin.y - 100, -1, -1);
        
        int changeOffset = 0;
        if (textField == self.toTextView)
            changeOffset = -100;
        else if (textField == self.fromTextView)
            changeOffset = 50;
        
        CGRect toFrame = self.toTextView.frame;
        self.toTextView.frame = CGRectify(toFrame, -1, toFrame.origin.y + changeOffset, -1, -1);
        
        CGRect buttonFrame = self.submitButton.frame;
        self.submitButton.frame = CGRectify(buttonFrame, -1, buttonFrame.origin.y + 50, -1, -1);
    } completion:^(BOOL finished) {
        self.searchResults.alpha = 0;
        self.searchResults.hidden = NO;
        
        int y = 0;
        if (textField == self.toTextView)
            y = self.toTextView.frame.origin.y + 40;
        else if (textField == self.fromTextView)
            y = self.fromTextView.frame.origin.y + 40;
        CGRect searchFrame = self.searchResults.frame;
        
        self.searchResults.frame = CGRectify(searchFrame, -1, y, -1, 0);
        [self.searchResults setNeedsDisplay];
        
        [UIView animateWithDuration:0.4 animations:^{
            self.searchResults.alpha = 1;
            
            CGFloat height = [self getTableViewHeight];
            self.searchResults.frame = CGRectify(searchFrame, -1, y, -1, height);
        }];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        self.searchResults.alpha = 0;
    } completion:^(BOOL finished) {
        self.searchResults.hidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect logoFrame = self.logoView.frame;
            self.logoView.frame = CGRectify(logoFrame, -1, logoFrame.origin.y + 100, -1, -1);
            
            CGRect fromFrame = self.fromTextView.frame;
            self.fromTextView.frame = CGRectify(fromFrame, -1, fromFrame.origin.y + 100, -1, -1);
            
            int changeOffset = 0;
            if (textField == self.toTextView)
                changeOffset = 100;
            else if (textField == self.fromTextView)
                changeOffset = -50;
            
            CGRect toFrame = self.toTextView.frame;
            self.toTextView.frame = CGRectify(toFrame, -1, toFrame.origin.y + changeOffset, -1, -1);
            
            CGRect buttonFrame = self.submitButton.frame;
            self.submitButton.frame = CGRectify(buttonFrame, -1, buttonFrame.origin.y - 50, -1, -1);
        }];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [autocomplete_array removeAllObjects];
    [self.searchResults reloadData];
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    NSString *url = @"/api/station/";
    NSString *query = [[NSString alloc] initWithFormat:@"%@?%@", substring, @"format=json"];
    url = [url stringByAppendingString:query];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:url];
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength < 3) {
        return YES;
    }
    
    [objectManager getObjectsAtPath:url
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                autocomplete_array = [NSMutableArray arrayWithArray:[mappingResult array]];
                                [self.searchResults reloadData];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Fel"
                                                                                      message:[error localizedDescription]
                                                                                     delegate:nil cancelButtonTitle:nil
                                                                            otherButtonTitles:@"Ok", nil];
                                alertView.titleLabel.textColor = [UIColor cloudsColor];
                                alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
                                alertView.messageLabel.textColor = [UIColor cloudsColor];
                                alertView.messageLabel.font = [UIFont flatFontOfSize:14];
                                alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
                                alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
                                alertView.defaultButtonColor = [UIColor cloudsColor];
                                alertView.defaultButtonShadowColor = [UIColor asbestosColor];
                                alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
                                alertView.defaultButtonTitleColor = [UIColor asbestosColor];
                                [alertView show];
                            }];
    return YES;
}

- (void)initSubmitButton
{
    self.submitButton.buttonColor = [UIColor turquoiseColor];
    self.submitButton.shadowColor = [UIColor greenSeaColor];
    self.submitButton.shadowHeight = 3.0f;
    self.submitButton.cornerRadius = 0.0f;
    [self.submitButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.fromTextView isFirstResponder] && [touch view] != self.fromTextView) {
        [self.fromTextView resignFirstResponder];
    } else if ([self.toTextView isFirstResponder] && [touch view] != self.toTextView) {
        [self.toTextView resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return autocomplete_array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchResultsIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Location *loc = [autocomplete_array objectAtIndex:indexPath.row];
    cell.textLabel.text = loc.name;
    cell.detailTextLabel.text = @"Något annat";
    
    return cell;
}

@end
