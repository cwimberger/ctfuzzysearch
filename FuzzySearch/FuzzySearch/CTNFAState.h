//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTNFAState : NSObject

@property (nonatomic, strong, readonly) id data;
@property (nonatomic, assign) BOOL final;

- (id)initWithData:(id)data;

- (void)addEdgeWithSymbol:(NSString*)symbol toState:(CTNFAState*)state;
- (NSSet*)edges;
- (NSSet*)followingStatesWithSymbol:(NSString*)symbol;

@end
