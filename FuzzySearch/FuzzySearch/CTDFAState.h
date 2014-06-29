//  Copyright (c) 2014 Christoph Wimberger. All rights reserved.

#import <Foundation/Foundation.h>

@interface CTDFAState : NSObject

@property (nonatomic, strong, readonly) id data;
@property (nonatomic, assign) BOOL final;

- (id)initWithData:(id)data;

- (void)addEdgeWithSymbol:(NSString*)symbol toState:(CTDFAState*)state;
- (NSSet*)edges;
- (CTDFAState*)followingStateWithSymbol:(NSString*)symbol;

@end
