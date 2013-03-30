//
//  CNoSpaceAutoTextField.m
//  BMD-X
//
//  Created by Steven Fuchs on 3/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CNoSpaceAutoTextField.h"
#import "BMDDocument.h"
#import "SpoiledTextField.h"

@implementation CNoSpaceAutoTextField


- (id)init
{
    self = [super init];
    if (self) {
        mIgnoreKeyUp = false;
    }
    return self;
}

-(void) setIgnoreKeyUp:(Boolean)doIgnore
{
    mIgnoreKeyUp = doIgnore;
}

- (BOOL)textView:(NSTextView *)atextView doCommandBySelector:(SEL)command
{
    NSString* cmdStr = NSStringFromSelector(command);

    if ([cmdStr isEqualToString:@"moveDown:"]) {
        mSearchGuesses = mSearchGuesses + 1;
        [self matchDocs:mTypedText];
        return YES;
    }
    if ([cmdStr isEqualToString:@"moveUp:"]) {
        mSearchGuesses = MAX( mSearchGuesses - 1, 0 );
        [self matchDocs:mTypedText];
        return YES;
    }
    return [super textView:atextView doCommandBySelector:command];
}

-(BOOL) becomeFirstResponder
{
    NSLog(@"become first responder");
    BOOL result = [super becomeFirstResponder];

    BMDDocument* aBDoc = (BMDDocument*)self.delegate;
    
    [[aBDoc getFieldEditor] setEditorParent:self];
    
    return result;
}


-(void) matchDocs:(NSString*) strtPt
{
    BMDDocument* theDoc = (BMDDocument*)[self delegate];
    NSString*  theAns = [theDoc getCompletionOf:self with:strtPt indexOfSelectedItem:mSearchGuesses];
    if ( theAns ) {
        [self setStringValue:theAns];
        NSText* textEditor = [self currentEditor];
        NSRange range = {[strtPt length], [theAns length]};
        [textEditor setSelectedRange:range];
        
    }
}

-(void)keyUp:(NSEvent *)event{
    int keyCode = [event.characters characterAtIndex:0];
    BMDDocument* theDoc = (BMDDocument*)[self delegate];

    if (keyCode != 13 && keyCode != 9 && keyCode != 127 && keyCode != NSUpArrowFunctionKey && keyCode != NSDownArrowFunctionKey) {
        mSearchGuesses = 0;
        [mTypedText autorelease];
        mTypedText = [[self stringValue] retain];
        [self matchDocs:[self stringValue]];
    }
    else
    {
    }
    if ( mIgnoreKeyUp ) {
        mIgnoreKeyUp = false;
    } else {
        [theDoc fieldText:self];
    }
    [super keyUp:event];
}
@end
