//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTIntTuple : NSObject <NSCopying>

@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign, readonly) NSInteger distance;

- (id)initWithIndex:(NSInteger)index andDistance:(NSInteger)distance;

@end
