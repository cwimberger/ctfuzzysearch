//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTNFA.h"

#import "CTNFAState.h"

@implementation CTNFA
{
    NSMutableDictionary *_CTstates;
    CTNFAState *_CTstart;
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
    CTNFAState *s = [_CTstates objectForKey:state];
    return s.final;
}

- (void)addEdge:(NSString*)symbol fromState:(id)from toState:(id)to
{
    CTNFAState *fromState = [self _CTaddState:from];
    CTNFAState *toState = [self _CTaddState:to];
    [fromState addEdgeWithSymbol:symbol toState:toState];
}

- (NSSet*)followingStatesFrom:(id)from withSymbol:(NSString*)symbol
{
    NSMutableSet *ret = [NSMutableSet new];
    CTNFAState *fromState = [_CTstates objectForKey:from];
    
    for(CTNFAState *state in [fromState followingStatesWithSymbol:symbol]) {
        [ret addObject:state.data];
    }
    
    return ret;
}

- (NSSet*)edgesFromState:(id)from
{
    CTNFAState *fromState = [_CTstates objectForKey:from];
    return [fromState edges];
}

- (NSSet*)epsilonStates:(NSSet*)states
{
    NSMutableSet *ret = [NSMutableSet new];
    NSMutableArray *todo = [NSMutableArray new];
    
    for(id state in states) [todo addObject:state];

    while([todo count]>0) {
        id curr = [todo lastObject];
        [todo removeLastObject];
        
        if(![ret containsObject:curr]) {
            [ret addObject:curr];
            
            for(NSString *symbol in [self edgesFromState:curr]) {
                if([symbol isEqualToString:@"_"]) {
                    for(id state in [self followingStatesFrom:curr withSymbol:symbol]) {
                        [todo addObject:state];
                    }
                }
            }
        }
    }
    
    return ret;
}

- (NSString*)description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendString:@"{ "];
    
    for(CTNFAState* state in [_CTstates allValues]) {
        for(NSString* x in state.edges) {
            [desc appendString:@"\""];
            [desc appendString:[state description]];
            [desc appendString:@"\" --"];
            [desc appendString:x];
            [desc appendString:@"--> "];
            [desc appendString:@"\""];
            [desc appendString:[[state followingStatesWithSymbol:x] description]];
            [desc appendString:@"\" "];
        }
    }
    
    [desc appendString:@"}"];
    return desc;
}

#pragma mark Private Methods

- (CTNFAState*)_CTaddState:(id)data
{
    CTNFAState *s = [_CTstates objectForKey:data];
    if(s==nil) {
        s = [[CTNFAState alloc] initWithData:data];
        [_CTstates setObject:s forKey:data];
    }
    return s;
}

@end
