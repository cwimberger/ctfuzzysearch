//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTNFA : NSObject

@property (strong, nonatomic) id startState;

- (void)addEdge:(NSString*)symbol fromState:(id)from toState:(id)to;
- (void)addFinalState:(id)state;
- (BOOL)isFinalState:(id)state;
- (NSSet*)followingStatesFrom:(id)from withSymbol:(NSString*)symbol;
- (NSSet*)epsilonStates:(NSSet*)states;
- (NSSet*)edgesFromState:(id)from;

@end
