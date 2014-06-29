//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTDFA.h"

#import "CTDFAState.h"

@implementation CTDFA
{
    NSMutableDictionary *_CTstates;
    CTDFAState *_CTstart;
}

- (id)init
{
    self = [super init];
    if (self) {
        _CTstates = [NSMutableDictionary new];
    }
    return self;
}

- (id)startState
{
    return _CTstart.data;
}

- (void)setStartState:(id)state
{
    _CTstart = [self _CTaddState:state];
}

- (void)addFinalState:(id)state
{
    [self _CTaddState:state].final = YES;
}

- (BOOL)isFinalState:(id)state
{
    CTDFAState *fromState = [_CTstates objectForKey:state];
    if(fromState==nil) return NO;
    return fromState.final;
}

- (id)followingStateFrom:(id)data withSymbol:(NSString*)symbol
{
    CTDFAState *fromState = [_CTstates objectForKey:data];
    if(fromState==nil) return nil;
    
    return [fromState followingStateWithSymbol:symbol].data;
}

- (void)addEdge:(NSString*)symbol fromState:(id)from toState:(id)to
{
    CTDFAState *fromState = [self _CTaddState:from];
    CTDFAState *toState = [self _CTaddState:to];
    [fromState addEdgeWithSymbol:symbol toState:toState];
}

- (NSSet*)edgesFromState:(id)from
{
    CTDFAState *fromState = [_CTstates objectForKey:from];
    return [fromState edges];
}

- (NSString*)description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendString:@"{ "];
    
    for(CTDFAState* state in [_CTstates allValues]) {
        for(NSString* x in state.edges) {
            [desc appendString:@"\""];
            [desc appendString:[state description]];
            [desc appendString:@"\" --"];
            [desc appendString:x];
            [desc appendString:@"--> "];
            [desc appendString:@"\""];
            [desc appendString:[[state followingStateWithSymbol:x] description]];
            [desc appendString:@"\" "];
        }
    }
    
    [desc appendString:@"}"];
    return desc;
}

#pragma mark Private Methods

- (CTDFAState*)_CTaddState:(id)data
{
    CTDFAState *s = [_CTstates objectForKey:data];
    if(s==nil) {
        s = [[CTDFAState alloc] initWithData:data];
        [_CTstates setObject:s forKey:data];
    }
    return s;
}

@end
