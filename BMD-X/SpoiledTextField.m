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
    if ( [[theEvent characters] isEqualToString:@" "] )
        [mParentDoc spareFieldOpening:mFieldEditorsParent];
    else if ( [[theEvent characters] isEqualToString:@" "] )
        [mParentDoc spareFieldOpening:mFieldEditorsParent];
    else
        [super keyDown:theEvent];
}
@end
