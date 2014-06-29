//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTDFA : NSObject

@property (nonatomic, strong) id startState;

- (void)addEdge:(NSString*)symbol fromState:(id)from toState:(id)to;
- (id)followingStateFrom:(id)from withSymbol:(NSString*)symbol;
- (void)addFinalState:(id)state;
- (BOOL)isFinalState:(id)state;
- (NSSet*)edgesFromState:(id)from;

@end
