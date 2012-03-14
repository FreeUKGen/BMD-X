//
//  CNoSpaceAutoTextField.m
//  BMD-X
//
//  Created by Steven Fuchs on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNoSpaceAutoTextField.h"

@implementation CNoSpaceAutoTextField


-(void)keyUp:(NSEvent *)event{
    int keyCode = [event.characters characterAtIndex:0];
    if (keyCode != 13 && keyCode != 9 && keyCode != 127 && keyCode != NSLeftArrowFunctionKey && keyCode != NSRightArrowFunctionKey) {
        [self.currentEditor complete:self];
    }
    [super keyUp:event];
}
@end
