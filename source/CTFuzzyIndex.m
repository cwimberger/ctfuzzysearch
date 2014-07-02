//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import "CTFuzzyIndex.h"

#import "CTDFA.h"
#import "CTNFA.h"
#import "CTIntTuple.h"
#import "CTFuzzyMatch.h"
#import "CTFuzzyMatch-Private.h"

@implementation CTFuzzyIndex
{
    CTDFA *_CTindex;
    NSMutableDictionary *_CTdata;
}

- (id)init
{
    self = [super init];
    if (self) {
        _CTindex = [CTDFA new];
        _CTindex.startState = @"";
        _CTdata = [NSMutableDictionary new];
    }
    return self;
}

- (void)addString:(NSString *)string
{
    [self addString:string withData:nil];
}

- (void)addString:(NSString*)string withData:(id)data
{
    NSString *w = [string lowercaseString];
    NSString *from = @"";
    for(int i=0;i<[w length];i++) {
        NSString *ch = [w substringWithRange:NSMakeRange(i, 1)];
        NSString *to = [w substringToIndex:i+1];
        [_CTindex addEdge:ch fromState:from toState:to];
        from = to;
    }
    [_CTindex addFinalState:w];

    if(data!=nil) {
        NSMutableArray *darr = [_CTdata objectForKey:w];
        if(darr==nil) {
            darr = [NSMutableArray new];
            [_CTdata setObject:darr forKey:w];
        }
        [darr addObject:data];
    }
}

- (void)addWordsFromString:(NSString *)string options:(CTFuzzyIndexOptions)opts
{
    BOOL ranges = opts & CTFuzzyIndexIncludeRanges;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        id data = nil;
        if(ranges) data = [NSValue valueWithRange:substringRange];
        [self addString:substring withData:data];
    }];
}

- (NSArray*)search:(NSString*)word withMaxDistance:(NSInteger)distance
{
    NSString *w = [word lowercaseString];
    NSMutableArray *ret = [NSMutableArray new];
    CTNFA *nfa = [self _CTcreateNFAWithWord:w withMaxDistance:distance];
    CTDFA *dfa1 = [self _CTcreateDFAFromNFA:nfa];
    CTDFA *dfa2 = _CTindex;
    
    NSMutableArray *s = [NSMutableArray new];
    [s addObject:[NSArray arrayWithObjects:@"", dfa1.startState, dfa2.startState, nil]];
    
    while([s count]>0) {
        NSArray *entry = [s lastObject];
        [s removeLastObject];
        NSString *trans = [entry objectAtIndex:0];
        id a = [entry objectAtIndex:1];
        id b = [entry objectAtIndex:2];
        
        NSMutableSet *trans1 = [[dfa1 edgesFromState:a] mutableCopy];
        NSMutableSet *trans2 = [[dfa2 edgesFromState:b] mutableCopy];
        
        NSMutableSet *x = trans2;
        if([trans1 containsObject:@"*"]) x = trans2;
        else [x intersectSet:trans1];
        
        for(NSString *edge in x) {
            id s1 = [dfa1 followingStateFrom:a withSymbol:edge];
            if(s1==nil) s1 = [dfa1 followingStateFrom:a withSymbol:@"*"];
            
            id s2 = [dfa2 followingStateFrom:b withSymbol:edge];
            
            if(s1!=nil && s2!=nil) {
                NSString *word = [trans stringByAppendingString:edge];
                [s addObject:[NSArray arrayWithObjects:word, s1, s2, nil]];
                
                if([dfa1 isFinalState:s1] && [dfa2 isFinalState:s2]) {
                    NSArray *data = [_CTdata objectForKey:word];
                    if(data!=nil) data = [data copy];
                    else data = [NSArray new];
                    
                    NSInteger dist = distance;
                    for(CTIntTuple *substate in s1) {
                        if([nfa isFinalState:substate]) {
                            if(substate.distance<dist) dist = substate.distance;
                        }
                    }
                    
                    CTFuzzyMatch *match = [[CTFuzzyMatch alloc] initWithStringValue:word withDistance:dist andData:data];
                    [ret addObject:match];
                }
            }
        }
    }
    
    [ret sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CTFuzzyMatch *m1 = obj1;
        CTFuzzyMatch *m2 = obj2;
        
        NSInteger m1cnt = m1.data==nil?0:[m1.data count];
        NSInteger m2cnt = m2.data==nil?0:[m2.data count];

        // sort by matches, distance, length, value
        if(m1cnt==m2cnt) {
            if(m1.distance==m2.distance) {
                if(m1.value.length==m2.value.length) {
                    return [m1.value compare:m2.value];
                } else {
                    return m1.value.length - m2.value.length;
                }
            } else {
                return m1.distance - m2.distance;
            }
        } else {
            return m2cnt - m1cnt;
        }
    }];
    
    return ret;
}

- (NSString*)description
{
    return [_CTindex description];
}

#pragma mark Private Methods

- (CTNFA*)_CTcreateNFAWithWord:(NSString*)word withMaxDistance:(NSInteger)distance
{
    CTNFA *nfa = [CTNFA new];
    nfa.startState = [[CTIntTuple alloc] initWithIndex:0 andDistance:0];
    
    for(int i=0;i<[word length];i++) {
        NSString *ch = [word substringWithRange:NSMakeRange(i, 1)];
        
        for(int e=0;e<distance+1;e++) {
            [nfa addEdge:ch fromState:[[CTIntTuple alloc] initWithIndex:i andDistance:e] toState:[[CTIntTuple alloc] initWithIndex:i+1 andDistance:e]];
            
            if(e<distance) {
                [nfa addEdge:@"*" fromState:[[CTIntTuple alloc] initWithIndex:i andDistance:e] toState:[[CTIntTuple alloc] initWithIndex:i andDistance:e+1]];
                [nfa addEdge:@"_" fromState:[[CTIntTuple alloc] initWithIndex:i andDistance:e] toState:[[CTIntTuple alloc] initWithIndex:i+1 andDistance:e+1]];
                [nfa addEdge:@"*" fromState:[[CTIntTuple alloc] initWithIndex:i andDistance:e] toState:[[CTIntTuple alloc] initWithIndex:i+1 andDistance:e+1]];
            }
        }
        
        for(int e=0;e<distance+1;e++) {
            if(e<distance) {
                [nfa addEdge:@"*" fromState:[[CTIntTuple alloc] initWithIndex:[word length] andDistance:e] toState:[[CTIntTuple alloc] initWithIndex:[word length] andDistance:e+1]];
            }
            [nfa addFinalState:[[CTIntTuple alloc] initWithIndex:[word length] andDistance:e]];
        }
    }
    
    return nfa;
}

- (CTDFA*)_CTcreateDFAFromNFA:(CTNFA*)nfa
{
    NSMutableSet *start = [NSMutableSet new];
    [start addObject:nfa.startState];
    [start addObjectsFromArray:[[nfa epsilonStates:start] allObjects]];
    
    CTDFA *dfa = [CTDFA new];
    dfa.startState = [NSSet setWithObject:nfa.startState];
    NSMutableArray *todo = [NSMutableArray new];
    NSMutableArray *done = [NSMutableArray new];
    [todo addObject:dfa.startState];
    
    while([todo count]>0) {
        NSSet *curr = [todo lastObject];
        [todo removeLastObject];
        
        if(![done containsObject:curr]) {
            [done addObject:curr];
            
            NSSet *currStates = curr;
            NSMutableArray *transitions = [NSMutableArray new];
            
            for(id state in currStates) {
                for(NSString *x in [nfa edgesFromState:state]) {
                    if(![x isEqualToString:@"_"] && ![transitions containsObject:x]) {
                        [transitions addObject:x];
                    }
                }
            }
            
            NSMutableSet *any = [NSMutableSet new];
            for(NSString *transition in transitions) {
                if([transition isEqualToString:@"*"]) {
                    [any addObjectsFromArray:[[self _CTcreateFollowingState:nfa withState:currStates withSymbol:transition] allObjects]];
                }
            }
            
            for(NSString *transition in transitions) {
                NSMutableSet *follow  = [[self _CTcreateFollowingState:nfa withState:currStates withSymbol:transition] mutableCopy];
                
                [follow addObjectsFromArray:[any allObjects]];
                [follow addObjectsFromArray:[[nfa epsilonStates:follow] allObjects]];
                NSMutableSet *fs = follow;
                
                for(id state in follow) {
                    if([nfa isFinalState:state]) {
                        [dfa addFinalState:fs];
                        break;
                    }
                }
                
                [dfa addEdge:transition fromState:curr toState:fs];
                [todo addObject:fs];
            }
        }
    }
    
    return dfa;
}

- (NSSet*)_CTcreateFollowingState:(CTNFA*)nfa withState:(NSSet*)state withSymbol:(NSString*)symbol
{
    NSMutableSet *follow = [NSMutableSet new];
    
    for(CTIntTuple *it in state) {
        [follow unionSet:[nfa followingStatesFrom:it withSymbol:symbol]];
    }
    
    return follow;
}

@end
