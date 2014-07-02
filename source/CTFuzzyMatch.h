//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTFuzzyMatch : NSObject

@property (nonatomic, assign, readonly) NSInteger distance;
@property (nonatomic, strong, readonly) NSArray *data;
@property (nonatomic, copy, readonly) NSString *value;

- (id)init __unavailable;
+ (id)new __unavailable;

@end
