//
//  ViewController.h
//  StringToNumber
//
//  Created by Steven Shatz on 1/7/15.
//  Copyright (c) 2015 Steven Shatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringConverter.h"


@interface ViewController : UIViewController

@property (retain, nonatomic) StringConverter *strConv;

@property (retain, nonatomic) NSString *resultToDisplay;

@property (weak, nonatomic) IBOutlet UITextField *stringText;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *addRandomNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@end

