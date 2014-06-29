//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTNFAState.h"

@implementation CTNFAState
{
    id _CTdata;
    NSMutableDictionary *_CTinternalEdges;
}

- (id)initWithData:(id)data
{
    self = [super init];
    if (self) {
        _CTdata = data;
        _CTinternalEdges = [NSMutableDictionary new];
        self.final = NO;
    }
    return self;
}

- (id)data
{
    return _CTdata;
}

- (void)addEdgeWithSymbol:(NSString*)symbol toState:(CTNFAState*)state
{
    NSMutableArray *states = [_CTinternalEdges objectForKey:symbol];
    if(states==nil) {
        states = [NSMutableArray new];
        [_CTinternalEdges setObject:states forKey:symbol];
    }
    
    [states addObject:state];
}

- (NSSet*)edges
{
    return [NSSet setWithArray:[_CTinternalEdges allKeys]];
}

- (NSSet*)followingStatesWithSymbol:(NSString*)symbol
{
    return [NSSet setWithArray:[_CTinternalEdges objectForKey:symbol]];
}

- (NSString*)description
{
    return self.final?[NSString stringWithFormat:@"<%@>", self.data]:[self.data description];
}

@end
