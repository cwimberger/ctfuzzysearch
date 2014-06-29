//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTFuzzyMatch.h"

@implementation CTFuzzyMatch
{
    NSInteger _CTdistance;
    NSArray *_CTdata;
    NSString *_CTvalue;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Init is not a valid initializer for the class CTFuzzyMatch." userInfo:nil];
}

- (id)initWithStringValue:(NSString*)value withDistance:(NSInteger)distance andData:(NSArray*)data
{
    self = [super init];
    if (self) {
        _CTvalue = value;
        _CTdistance = distance;
        _CTdata = data;
    }
    return self;
}

- (NSInteger)distance
{
    return _CTdistance;
}

- (NSArray *)data
{
    return _CTdata;
}

- (NSString *)value
{
    return _CTvalue;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"{ value: %@, distance: %ld, data: %@ }", _CTvalue, (long)_CTdistance, _CTdata];
}

@end
