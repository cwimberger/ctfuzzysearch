//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTIntTuple.h"

@implementation CTIntTuple
{
    NSInteger _CTindex;
    NSInteger _CTdistance;
}

- (id)initWithIndex:(NSInteger)index andDistance:(NSInteger)distance
{
    self = [super init];
    if (self) {
        _CTindex = index;
        _CTdistance = distance;
    }
    return self;
}

- (NSInteger)index
{
    return _CTindex;
}

- (NSInteger)distance
{
    return _CTdistance;
}

- (BOOL)isEqual:(id)anObject
{
    if (![anObject isKindOfClass:[CTIntTuple class]]) return NO;
    CTIntTuple *other = (CTIntTuple *)anObject;
    return self.index == other.index && self.distance == other.distance;
}

- (NSUInteger)hash
{
    NSUInteger result = 1;
    result = 31 * result + self.index;
    result = 31 * result + self.distance;
    return result;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithIndex:self.index andDistance:self.distance];
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"(%ld_%ld)", (long)_CTindex, (long)_CTdistance];
}

@end
