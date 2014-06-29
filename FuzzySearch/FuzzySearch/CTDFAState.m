//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTDFAState.h"

@implementation CTDFAState
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

- (CTDFAState*)followingStateWithSymbol:(NSString*)symbol
{
    return [_CTinternalEdges objectForKey:symbol];
}

- (void)addEdgeWithSymbol:(NSString*)symbol toState:(CTDFAState*)state
{
    [_CTinternalEdges setObject:state forKey:symbol];
}

- (NSSet*)edges
{
    return [NSSet setWithArray:[_CTinternalEdges allKeys]];
}

- (NSString*)description
{
    return self.final?[NSString stringWithFormat:@"<%@>", _CTdata]:[_CTdata description];
}

@end
