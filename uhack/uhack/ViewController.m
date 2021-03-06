//
//  ViewController.m
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "UIFont+FlatUI.h"
#import "QuartzCore/QuartzCore.h"
#import <RestKit/RestKit.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import "NSString+Extended.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "UIColor+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "Location.h"
#import "Travel.h"

@interface ViewController ()

@property (nonatomic, retain) Location *fromLocation;
@property (nonatomic, retain) Location *toLocation;

@end

@implementation ViewController {
    NSMutableArray *org_array;
    NSMutableArray *autocomplete_array;
    UITextField *currentFirstResponder;
    BOOL calculate;
    Travel *currentTravel;
    CGFloat priceOriginalY, logoOriginalY, travelerTypeOriginalY, fromOriginalY, toOriginalY, submitOriginalY;
    NSString *currentTravelerType;
    MFMessageComposeViewController *messageController;
}

#define UPOFFSET 84
#define DOWNOFFSET 50

#define COUNTPRICE @"Räkna pris"
#define SENDTEXT @"Skicka SMS"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentTravelerType = @"H";

    org_array = [[NSMutableArray alloc] init];
    autocomplete_array = [[NSMutableArray alloc] init];
    calculate = YES;
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
    [self initSegmentControl];
    
    priceOriginalY = 0;
    logoOriginalY = self.logoView.frame.origin.y;
    travelerTypeOriginalY = self.travelerTypeControl.frame.origin.y;
    fromOriginalY = self.fromTextView.frame.origin.y;
    toOriginalY = self.toTextView.frame.origin.y;
    submitOriginalY = self.submitButton.frame.origin.y;
}

- (void)initSegmentControl
{
    self.travelerTypeControl.tintColor = [UIColor turquoiseColor];
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
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.searchResults.superview != nil) {
        if ([touch.view isDescendantOfView:self.searchResults]) {
            // we touched the search view
            return NO; // ignore the touch
        }
    }
    if (self.fromTextView.superview != nil) {
        if ([touch.view isDescendantOfView:self.fromTextView]) {
            // we touched the search view
            [self expandFrom];
            return NO; // ignore the touch
        }
    }
    if (self.toTextView.superview != nil) {
        if ([touch.view isDescendantOfView:self.toTextView]) {
            // we touched the search view
            [self expandTo];
            return NO; // ignore the touch
        }
    }
    return YES; // handle the touch
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    [self closeFields];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.fromTextView) {
        [self.toTextView becomeFirstResponder];
        [self expandToAfterClosingFrom];
    }
    else if (textField == self.toTextView)
    {
        [textField resignFirstResponder];
        [self closeFields];
    }
    return YES;
}

- (void)expandFrom
{
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect logoFrame = self.logoView.frame;
                         self.logoView.frame = CGRectify(logoFrame, -1, logoOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect travelerFrame = self.travelerTypeControl.frame;
                         self.travelerTypeControl.frame = CGRectify(travelerFrame, -1, travelerTypeOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect fromFrame = self.fromTextView.frame;
                         self.fromTextView.frame = CGRectify(fromFrame, -1, fromOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect toFrame = self.toTextView.frame;
                         self.toTextView.frame = CGRectify(toFrame, -1, toOriginalY + DOWNOFFSET, -1, -1);
                         
                         CGRect buttonFrame = self.submitButton.frame;
                         self.submitButton.frame = CGRectify(buttonFrame, -1, submitOriginalY + DOWNOFFSET, -1, -1);
                     } completion:^(BOOL finished) {
                         self.searchResults.alpha = 0;
                         
                         int y = fromOriginalY - UPOFFSET + 40;
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

- (void)expandToAfterClosingFrom
{
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.searchResults.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self expandTo];
                     }];
}

- (void) expandFromAfterClosingTo
{
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.searchResults.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self expandTo];
                     }];
}

- (void)expandTo
{
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect logoFrame = self.logoView.frame;
                         self.logoView.frame = CGRectify(logoFrame, -1, logoOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect travelerFrame = self.travelerTypeControl.frame;
                         self.travelerTypeControl.frame = CGRectify(travelerFrame, -1, travelerTypeOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect fromFrame = self.fromTextView.frame;
                         self.fromTextView.frame = CGRectify(fromFrame, -1, fromOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect toFrame = self.toTextView.frame;
                         self.toTextView.frame = CGRectify(toFrame, -1, toOriginalY - UPOFFSET, -1, -1);
                         
                         CGRect buttonFrame = self.submitButton.frame;
                         self.submitButton.frame = CGRectify(buttonFrame, -1, submitOriginalY + DOWNOFFSET, -1, -1);
                     } completion:^(BOOL finished) {
                         self.searchResults.alpha = 0;
                         
                         int y = toOriginalY - UPOFFSET + 40;
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

- (void)closeFields
{
    [self.view.layer removeAllAnimations];
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.searchResults.alpha = 0;
                     } completion:^(BOOL finished) {
                         //self.searchResults.hidden = YES;
                         [UIView animateWithDuration:0.3 animations:^{
                             CGRect logoFrame = self.logoView.frame;
                             self.logoView.frame = CGRectify(logoFrame, -1, logoOriginalY, -1, -1);
                             
                             CGRect travelerFrame = self.travelerTypeControl.frame;
                             self.travelerTypeControl.frame = CGRectify(travelerFrame, -1, travelerTypeOriginalY, -1, -1);
                             
                             CGRect fromFrame = self.fromTextView.frame;
                             self.fromTextView.frame = CGRectify(fromFrame, -1, fromOriginalY, -1, -1);
                             
                             CGRect toFrame = self.toTextView.frame;
                             self.toTextView.frame = CGRectify(toFrame, -1, toOriginalY, -1, -1);
                             
                             CGRect buttonFrame = self.submitButton.frame;
                             self.submitButton.frame = CGRectify(buttonFrame, -1, submitOriginalY, -1, -1);
                         }];
                     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (calculate == NO) {
        calculate = YES;
        [self.submitButton setTitle: COUNTPRICE forState:UIControlStateNormal];
    }
    
    currentFirstResponder = textField;
    [autocomplete_array removeAllObjects];
    [self.searchResults reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField { }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // @TODO: Make sure to kill all the previous connections so we dont
    // populate the other input text
    [autocomplete_array removeAllObjects];
    [self.searchResults reloadData];
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    substring = [substring urlencode];
    
    // @TODO: Add version to API, and its an ugly way to do the api querystring.
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
                                debugLog(@"Error: %@", [error localizedDescription]);
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
    
    [self.submitButton addTarget:self action:@selector(submitPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction) submitPressed:(id)sender {
    if (calculate == NO) {
        messageController = [[MFMessageComposeViewController alloc] init];
        if ([MFMessageComposeViewController canSendText]) {
            messageController.body = self->currentTravel.msgText;
            messageController.recipients = [NSArray arrayWithObjects:self->currentTravel.msgNumber, nil];
            messageController.messageComposeDelegate = self;
            [self presentModalViewController:messageController animated:YES];
        }

        return;
    }
    Location *from = self.fromLocation;
    Location *to = self.toLocation;
    
    if (!from || !to) {
        //@TODO: Add version to API
        FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Fel"
                                                              message:@"Fyll i alla fält"
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
        
        return;
    }
    
    NSString *query = [[NSString alloc] initWithFormat:@"/api/ticketinfo/%d/%d/%@", [from.ID integerValue], [to.ID integerValue], currentTravelerType];
    NSString *url = [[NSString alloc] initWithFormat:@"%@?%@", query, @"format=json"];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:url];
    
    [objectManager getObjectsAtPath:url
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                currentTravel = [[mappingResult array] objectAtIndex:0];
                                [self.priceIndicator setText: [NSString stringWithFormat:@"%@:-", [NSString stringWithString:[currentTravel.price stringValue]]]];
                                [self.priceIndicator setTextColor:[UIColor whiteColor]];
                                
                                [self.submitButton setTitle:SENDTEXT forState:UIControlStateNormal];
                                self->calculate = NO;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultsIdentifier"];
    }
    
    Location *loc = [autocomplete_array objectAtIndex:indexPath.row];
    cell.textLabel.text = loc.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentFirstResponder == self.fromTextView) {
        self.fromLocation = [autocomplete_array objectAtIndex:indexPath.row];
        self.fromTextView.text = self.fromLocation.name;
        if (self.toLocation == nil) {
            [self expandToAfterClosingFrom];
            [self.toTextView becomeFirstResponder];
        }
        else {
            [self dismissKeyboard];
        }
    }
    else if (currentFirstResponder == self.toTextView) {
        self.toLocation = [autocomplete_array objectAtIndex:indexPath.row];
        self.toTextView.text = self.toLocation.name;
        if (self.fromLocation == nil) {
            [self expandFromAfterClosingTo];
            [self.fromTextView becomeFirstResponder];
        }
        else {
            [self dismissKeyboard];
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //hide mail composer
    [messageController dismissModalViewControllerAnimated:YES];
}

- (IBAction)switchedTravelerType:(id)sender
{
    calculate = YES;
    self.submitButton.titleLabel.text = COUNTPRICE;
    currentTravelerType = self.travelerTypeControl.selectedSegmentIndex == 0 ? @"H" : @"R";
}

@end
