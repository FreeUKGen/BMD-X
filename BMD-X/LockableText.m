    //
//  LockableText.m
//  BMD-X
//
//  Created by Steven Fuchs on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "LockableText.h"
#import "BMDDocument.h"


@implementation LockableText

- (id)init
{
    self = [super init];
    if (self) {
        mIsLocked = false;
    }
    
    return self;
}
- (BOOL)becomeFirstResponder
{
    return true;
}
- (void)dealloc
{
    [super dealloc];
}

- (void) setIsLocked:(BOOL)isIt {
    mIsLocked = isIt;
}
- (BOOL) getIsLocked {
    return mIsLocked;
}

@end
