//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>
#import "CTFuzzyMatch.h"

@interface CTFuzzyMatch (private)

- (id)initWithStringValue:(NSString*)value withDistance:(NSInteger)distance andData:(NSArray*)data;

@end
