//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CTFuzzyIndexOptions) {
    CTFuzzyIndexIncludeRanges = 1
};

@interface CTFuzzyIndex : NSObject

- (void)addString:(NSString*)string;
- (void)addString:(NSString*)string withData:(id)data;
- (void)addWordsFromString:(NSString *)string options:(CTFuzzyIndexOptions)opts;
- (NSArray*)search:(NSString*)string withMaxDistance:(NSInteger)distance;

@end
