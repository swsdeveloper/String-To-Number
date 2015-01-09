//
//  StringConverter.m
//  StringToNumber
//
//  Created by Steven Shatz on 1/8/15.
//  Copyright (c) 2015 Steven Shatz. All rights reserved.
//

#import "StringConverter.h"
#import "Constants.h"


@implementation StringConverter

- (id)init {
    self = [super init];
    if (self) {
        _errorMessage = @"";
    }
    return self;
}

- (NSString *)trimString:(NSString *)string {
    
    // Strip surrounding white space from number
    
    NSString *trimmedStr = [string stringByReplacingOccurrencesOfString:@"^\\s+|\\s+$"     // Regular Expression
                                                             withString:@""
                                                                options:NSRegularExpressionSearch
                                                                  range:NSMakeRange(0, string.length)];
    //    NSLog(@"Original: %@, trimmed: %@", string, trimmedStr);
    
    return trimmedStr;
}

- (numType)getTypeOfNumberFromString:(NSString *)string {
    
    self.errorMessage = @"";
    
    string = [self trimString:string];
    
    enum numType type;
    
    type = invalid;
    
    // Are there any characters left in string?
    
    if (string.length < 1) {
        self.errorMessage = @"Error: No number was input";
        NSLog(@"%@", self.errorMessage);
        return type;
    }
    
    // Does string contain other than digits and decimal points?
    
    NSString *pattern = @"[^\\d\\.]";
    NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regEx matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if ([matches count] > 0) {
        self.errorMessage = [NSString stringWithFormat:@"Error: Invalid number contains one or more characters that are neither digits nor decimal points: %@", string];
        NSLog(@"%@", self.errorMessage);
        return type;
    }
    
    // Does string contain a decimal point? Is there more than 1 decimal point?
    
    NSArray *stringParts = [string componentsSeparatedByString:@"."];
    
    switch ([stringParts count]) {
        case 0:
            self.errorMessage = @"Error: No number was input [2]";   // previously trapped, should never happen here
            NSLog(@"%@", self.errorMessage);
            break;
        case 1:
            type = integer;
            break;
        case 2:
            type = decimal;
            break;
        default:    // count > 2
            self.errorMessage = [NSString stringWithFormat:@"Error: Invalid number contains more than 1 decimal point: %@", string];
            NSLog(@"%@", self.errorMessage);
    }

    return type;
}

- (NSNumber *)getNumberFromString:(NSString *)string ofType:(numType)type {
    
    self.errorMessage = @"";
    
    string = [self trimString:string];

    NSNumber *result;

    // if type = integer: "123" -> 123; "00123" -> 123
    // if type = decimal: "1.23" -> 1.23; "1.023" -> 1.023; "001.002300" -> 1.0023
    
    switch (type) {
        case integer:
            result = [self convertStringToInteger:string];
            break;
        case decimal:
            result = [self convertStringToDecimal:string];
            break;
        default:
            result = [NSNumber numberWithInteger:-9993];
            self.errorMessage = [NSString stringWithFormat:@"Error: invalid type (should never be other than integer or decimal): %@", string];
            NSLog(@"%@", self.errorMessage);
    }
    
    return result;
}

- (NSNumber *)convertStringToInteger:(NSString *)string {
    
    NSNumber *result;
    
    NSInteger total = 0;
    for (NSInteger n=0; n<string.length; ++n) {
        if (total > 0) {
            total = total * 10;
        }
        NSString *str = [string substringWithRange:NSMakeRange(n, 1)];
        total = total + [str integerValue];
    }
    
    result = [NSNumber numberWithInteger:total];
    
//    NSLog(@"string \"%@\" --> integer: %ld", string, [result integerValue]);
    
    return result;
}

- (NSNumber *)convertStringToDecimal:(NSString *)string {
    
    NSNumber *result;
    
    // Separate into Left and Right components
    
    NSArray *stringParts = [string componentsSeparatedByString:@"."];
    
    if ([stringParts count] != 2) {
        result = [NSNumber numberWithInteger:-9994];
        self.errorMessage = [NSString stringWithFormat:@"Error: Decimal number contains 0 or more than 1 decimal point: %@", string];     // should never happen!
        NSLog(@"%@", self.errorMessage);
        return result;
    }
    
    NSString *leftPartOfNumber = stringParts[0];
    NSString *rightPartOfNumber = stringParts[1];
    
    NSInteger integerLeftOfDecimal;
    double doubleRightOfDecimal;
    
    // Left component has integer value
    
    integerLeftOfDecimal = [[self convertStringToInteger:leftPartOfNumber] integerValue];
    
    // Right component has decimal value
    
    double total = 0.0;
    double divisor = 10.0;
    for (NSInteger n=0; n<rightPartOfNumber.length; ++n) {
        NSString *str = [rightPartOfNumber substringWithRange:NSMakeRange(n, 1)];
        total = total + ([str doubleValue] / divisor);
        divisor = divisor * 10;
    }
    doubleRightOfDecimal = total;

    // The sum of both components is the result we want
    
    double sum = (double)integerLeftOfDecimal + doubleRightOfDecimal;
    
    result = [NSNumber numberWithDouble:sum];
    
//    NSString *stringPattern=[NSString stringWithFormat:@"%%0.%ldf", rightPartOfNumber.length];  // @"%0.nf"
//    
//    NSLog(@"string \"%@\" --> decimal: %@", string, [NSString stringWithFormat:stringPattern, [result doubleValue]]);

    return result;
}

@end
