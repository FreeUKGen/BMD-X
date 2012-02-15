//
//  LockableText.h
//  BMD-X
//
//  Created by Steven Fuchs on 1/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMDDocument;

@interface LockableText : NSTextField {
    BOOL                mIsLocked;
    BMDDocument*        mParentDoc;

@private
    
}
- (void) setIsLocked:(BOOL)isIt;
- (BOOL) getIsLocked;

@end
