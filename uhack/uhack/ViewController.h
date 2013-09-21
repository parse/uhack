//
//  ViewController.h
//  uhack
//
//  Created by Anders Hassis on 2013-09-21.
//  Copyright (c) 2013 Anders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"


@interface ViewController : UIViewController

@property (nonatomic, retain) IBOutlet FUIButton *submitButton;
@property (nonatomic, retain) IBOutlet UITextView *fromTextView;
@property (nonatomic, retain) IBOutlet UITextView *toTextView;

@end
