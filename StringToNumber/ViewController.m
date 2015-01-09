//
//  ViewController.m
//  StringToNumber
//
//  Created by Steven Shatz on 1/7/15.
//  Copyright (c) 2015 Steven Shatz. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

//#define maxLengthOfInput 15


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.strConv = [[StringConverter alloc] init];
    
//    [self tests];
}

- (IBAction)convertToNumberButtonPressed:(UIButton *)sender {
    
//    NSInteger lengthOfInput = [self.stringText.text length];
//    if (lengthOfInput > maxLengthOfInput) {
//        self.resultToDisplay = [NSString stringWithFormat: @"Error: Number is longer than max length supported"];
//        NSLog(@"%@", self.resultToDisplay);
//        return;
//    }
    
    NSNumber *result = [self convertStringToNumber:self.stringText.text];
    
    self.resultLabel.text = self.resultToDisplay;
    
    // To prove that result is a real number, add a random value to it and display the sum
    
    self.addRandomNumberLabel.text = @"";
    self.randomAddLabel.text = @"";
    self.sumLabel.text = @"";
    
    // if any kind of error occurred, we're done
    
    if (result < 0) {
        return;
    }

    numType type = [self.strConv getTypeOfNumberFromString:self.stringText.text];
    
    // Gen random number to add to result (if result is not negative - i.e., if there was no error)
    
    NSInteger randomInt;
    double randomDouble;
    
    NSInteger newIntResult;
    double newDoubleResult;
    
    switch (type) {
        case integer:
            self.addRandomNumberLabel.text = @"Adding random integer";
            randomInt = arc4random_uniform(99) + 1;     // gen random integer between 1 and 100, inclusive
            self.randomAddLabel.text = [NSString stringWithFormat:@" + %ld", randomInt];
            newIntResult = [result integerValue] + randomInt;
            self.sumLabel.text = [NSString stringWithFormat:@"%ld", newIntResult];
            break;
        case decimal:
            self.addRandomNumberLabel.text = @"Adding random double";
            randomInt = arc4random_uniform(5);          // gen random integer between 0 and 5, inclusive
            randomDouble = drand48();                   // gen random double between 0.0 and 1.0, inclusive
            randomDouble = (double)randomInt + randomDouble;
            self.randomAddLabel.text = [NSString stringWithFormat:@" + %f", randomDouble];
            newDoubleResult = [result doubleValue] + randomDouble;
            self.sumLabel.text = [NSString stringWithFormat:@"%f", newDoubleResult];
    }
}

- (void)tests {
    [self convertStringToNumber:@"0"];                  // 0
    [self convertStringToNumber:@"0000"];               // 0
    [self convertStringToNumber:@"1"];                  // 1
    [self convertStringToNumber:@"23"];                 // 23
    [self convertStringToNumber:@"123"];                // 123
    [self convertStringToNumber:@"00123"];              // 123
    [self convertStringToNumber:@"  123456    "];       // 123456
    
    [self convertStringToNumber:@"0.0"];                // 0.0  - ng "0"
    [self convertStringToNumber:@"1.0"];                // 1.0
    [self convertStringToNumber:@"23.00"];              // 23.0
    [self convertStringToNumber:@"1.23"];               // 1.23
    [self convertStringToNumber:@"1.023"];              // 1.023
    [self convertStringToNumber:@"001.002300"];         // 1.0023
    [self convertStringToNumber:@"3.1456"];             // 3.1456
    [self convertStringToNumber:@"  3.00001456  "];     // 3.00001456

    [self convertStringToNumber:@""];                   // Invalid - no input
    [self convertStringToNumber:@"   "];                // Invalid - no input (after trimming lead/trail spaces)
    [self convertStringToNumber:@"1,234"];              // Invalid - invalid character (comma)
    [self convertStringToNumber:@"-123"];               // Invalid - invalid character (minus)
    [self convertStringToNumber:@"123.45 6"];           // Invalid - invalid character (internal space)
    [self convertStringToNumber:@"123.45ABC"];          // Invalid - invalid characters ("ABC")
    [self convertStringToNumber:@"1.2.3"];              // Invalid - too many decimal points
}

- (NSNumber *)convertStringToNumber:(NSString *)string {
    
    NSNumber *result;
    
    self.resultToDisplay = @"";

    numType type = [self.strConv getTypeOfNumberFromString:string];
    
//    NSLog(@"String type is: %d", type);
    
    if (![self.strConv.errorMessage isEqualToString:@""]) {
        result = [NSNumber numberWithInteger:-9991];
        self.resultToDisplay = self.strConv.errorMessage;
        return result;
    }
    
    switch (type) {
        case integer:
            result = [self.strConv getNumberFromString:string ofType:type];
            self.resultToDisplay = [NSString stringWithFormat:@"%ld", [result integerValue]];
            NSLog(@"%@", self.resultToDisplay);
            break;
        case decimal:
            result = [self.strConv getNumberFromString:string ofType:type];
            NSArray *stringParts = [string componentsSeparatedByString:@"."];
            if ([stringParts count] > 0) {
                NSString *rightPartOfNumber = stringParts[1];
                NSString *trimmedRightPartOfNumber = [self.strConv trimString:rightPartOfNumber];
                NSString *stringPattern = [NSString stringWithFormat:@"%%0.%ldf", trimmedRightPartOfNumber.length];  // @"%0.nf"
                self.resultToDisplay = [NSString stringWithFormat: @"%@", [NSString stringWithFormat:stringPattern, [result doubleValue]]];
                NSLog(@"%@", self.resultToDisplay);
            } else {
                result = [NSNumber numberWithInteger:-9992];
                self.resultToDisplay = [NSString stringWithFormat: @"Error: Somehow decimal number is missing decimal point - should never happen: %@", string];
                NSLog(@"%@", self.resultToDisplay);
            }
    }
    
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
