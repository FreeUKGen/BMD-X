//
//  CNoSpaceAutoTextField.h
//  BMD-X
//
//  Created by Steven Fuchs on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface CAutoTextField : NSTextField
{
    NSUInteger     mSearchGuesses;
    NSString* mTypedText;
}

-(Boolean) matchDocs:(NSString*)strtTx;

@end
