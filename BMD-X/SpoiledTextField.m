//
//  SpoiledTextField.m
//  BMD-X
//
//  Created by Steven Fuchs on 2/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SpoiledTextField.h"


@implementation CSpoiledTextField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil)
	{
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

-(void) setEditorParent:(NSTextField*)thePar
{
    mFieldEditorsParent = thePar;
}
-(void) setParentDoc:(BMDDocument*)thePar
{
    mParentDoc = thePar;
}
- (void)keyDown:(NSEvent *)theEvent
{
    BOOL isHandled = false;
    if ( [[theEvent characters] isEqualToString:@" "] )
        isHandled = [mParentDoc spareFieldOpening:mFieldEditorsParent];
    else if ( [[theEvent characters] isEqualToString:@" "] )
        isHandled = [mParentDoc spareFieldOpening:mFieldEditorsParent];
    
    if ( ! isHandled )
    {
        [super keyDown:theEvent];
        int keyCode = [theEvent.characters characterAtIndex:0];
        
        if (keyCode != 13 && keyCode != 9 && keyCode != 127 && keyCode != NSUpArrowFunctionKey && keyCode != NSDownArrowFunctionKey)
            [mParentDoc fieldText:mFieldEditorsParent];
    }
}
@end
