//
//  StringConverter.h
//  StringToNumber
//
//  Created by Steven Shatz on 1/8/15.
//  Copyright (c) 2015 Steven Shatz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringConverter : NSObject

enum numType {
    invalid,    // = 0
    integer,    // = 1
    decimal     // = 2
};

typedef int numType;

@property (retain, nonatomic) NSString *errorMessage;

- (NSString *)trimString:(NSString *)string;

- (numType)getTypeOfNumberFromString:(NSString *)string;

- (NSNumber *)getNumberFromString:(NSString *)string ofType:(numType)type;

@end
