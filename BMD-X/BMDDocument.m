//
//  BMDDocument.m
//  BMD-X
//
//  Created by Steven Fuchs on 1/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BMDDocument.h"

@interface BMDDocument (Internals)

- (void)sendText:(NSString*) aStr;
- (void)getMessage:(NSNotification *)aNotification;

@end

@implementation BMDDocument

- (id)init
{
    self = [super init];
    if (self) {
        if (mString == nil) {
            mString = [[NSAttributedString alloc] initWithString:@""];
        }    
    }
    return self;
}

- (IBAction)textFieldAction:(id)sender {
    [self.windowForSheet selectKeyViewFollowingView:sender];
}

- (void)textFieldClosing:(id)fieldOb
{
    NSArray *lines = [[[textView textStorage] mutableString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
    BOOL    emptyLine = false;
    
    if ( lines.count == 0 || [[lines objectAtIndex:(lines.count - 1)] isEqualToString:@""] )
        emptyLine = true;
    
    if (fieldOb == msSurnameFld){
        NSString*   surStr = [msSurnameFld stringValue];
        if ( [msCapsBtn state] == NSOnState )
            surStr = [surStr uppercaseString];
        if ( !emptyLine )
            surStr = [NSString stringWithFormat:@"\r%@", surStr];

        surStr = [NSString stringWithFormat:@"%@,", surStr];
        
        [self sendText:surStr];
    }
    else if (fieldOb == msFirstnameFld){        
        [self sendText:[NSString stringWithFormat:@"%@,", [msFirstnameFld stringValue]]];
    }
    else if (fieldOb == msDistrictFld){        
        [self sendText:[NSString stringWithFormat:@"%@,", [msDistrictFld stringValue]]];
    }
    else if (fieldOb == msVolumeFld){        
        [self sendText:[NSString stringWithFormat:@"%@,", [msVolumeFld stringValue]]];
    }
    else if (fieldOb == msPageFld){        
        [self sendText:[NSString stringWithFormat:@"%@\r", [msPageFld stringValue]]];
        if ( [msLockedBtn state] == NSOnState )
            [self textFieldClosing:msSurnameFld];
    }
}

- (void)getMessage:(NSNotification *)aNotification
{
    if ([[[aNotification userInfo] valueForKey:@"NSTextMovement"] intValue] == NSTabTextMovement){
        NSLog( @"got the tab message" );
        [self textFieldClosing:[aNotification object]];
    }
    if ([[[aNotification userInfo] valueForKey:@"NSTextMovement"] intValue] == NSReturnTextMovement){
        NSLog( @"got the return message" );
        [self textFieldClosing:[aNotification object]];        
    }
    if ([[[aNotification userInfo] valueForKey:@"NSTextMovement"] intValue] == NSBacktabTextMovement) {
        NSLog( @"got the back tab message" );
        [self textFieldClosing:[aNotification object]];        
    }
    
}

- (NSAttributedString *) string { return [[mString retain] autorelease]; }

- (IBAction)setSurNameLock:(id)sender {

    if ( [msLockedBtn state] == NSOnState ) {
        [msPageFld setNextKeyView:msFirstnameFld];
        if ( [msSurnameFld currentEditor] ) {
            [self textFieldClosing:msSurnameFld];
            [self.windowForSheet makeFirstResponder:msFirstnameFld];
        }
    }
    else
        [msPageFld setNextKeyView:msSurnameFld];
}

- (void) setString: (NSAttributedString *) newValue {
    
    if (mString != newValue) {
        if (mString) [mString release];
        mString = [newValue copy];
    }
}

- (IBAction)sendBreak:(id)sender
{
    [self sendText:[NSString stringWithFormat:@"+BREAK\r", [pageFieldSolo stringValue]]];
}

- (IBAction)startPage:(id)sender{
    [NSApp beginSheet:mPageWindow modalForWindow:self.windowForSheet modalDelegate:self didEndSelector:@selector(cancelAction:returnCode:contextInfo:) contextInfo:@"entry"];
}

- (IBAction)okPageDLOG:(id)sender
{    
    [self sendText:[NSString stringWithFormat:@"+PAGE,%@\r", [pageFieldSolo stringValue]]];
    [NSApp endSheet:mPageWindow returnCode:[sender tag]];
}

- (IBAction)cancelPage:(id)sender{
    [NSApp endSheet:mPageWindow returnCode:[sender tag]];
}

- (IBAction)startComment:(id)sender{
    [NSApp beginSheet:mCommentWindow modalForWindow:self.windowForSheet modalDelegate:self didEndSelector:@selector(cancelAction:returnCode:contextInfo:) contextInfo:@"entry"];
}
- (IBAction)okCommentDLOG:(id)sender{
    NSString* string = [NSString stringWithFormat:@"#THEORY %@\r", [commentField stringValue]];

    [[[textView textStorage] mutableString] appendString: string];
    [NSApp endSheet:mCommentWindow returnCode:[sender tag]];
}
- (IBAction)cancelComment:(id)sender{
    [NSApp endSheet:mCommentWindow returnCode:[sender tag]];
}

- (IBAction)okSourceDLOG:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString* aStr = [dateFormatter stringFromDate:[dateField dateValue]];

    NSMutableString* string = [NSMutableString stringWithFormat:@"+%@,%@,%@", [[[formatMenu selectedItem] title] substringToIndex:1], [yearField stringValue], [[quarterMenu selectedItem] title]];

    if ( ! [[rangeField stringValue] isEqualToString:@""] )
        [string appendString:[NSString stringWithFormat:@",%@", [rangeField stringValue]]];
    if ( ! [[locationField stringValue] isEqualToString:@""] )
        [string appendString:[NSString stringWithFormat:@",%@", [locationField stringValue]]];
    if ( ! [[freeBMDRefField stringValue] isEqualToString:@""] )
        [string appendString:[NSString stringWithFormat:@",%@", [freeBMDRefField stringValue]]];

    [string appendString:[NSString stringWithFormat:@",%@\r",aStr]];
    
    if ( ! [[pageField stringValue] isEqualToString:@""] )
        [string appendString:[NSString stringWithFormat:@"+PAGE,%@\r", [pageField stringValue]]];
    
    
    [self sendText:string];
    
    [NSApp endSheet:mSourceWindow returnCode:[sender tag]];
}
- (IBAction)okEntryDLOG:(id)sender
{
    [self sendText:[NSString stringWithFormat:@"+INFO,%@,%@,%@,%@,macintosh\r", [emailField stringValue], [passwordField stringValue], 
                    [[orderMenu selectedItem] title], [[typeMenu selectedItem] title]]];
    
    [NSApp endSheet:mEntryWindow returnCode:[sender tag]];
}
- (IBAction)cancelSource:(id)sender
{
    [NSApp endSheet:mSourceWindow returnCode:[sender tag]];
}

- (IBAction)cancelEntry:(id)sender
{
    [NSApp endSheet:mEntryWindow returnCode:[sender tag]];
}

- (IBAction)startEntry:(id)sender
{
	[NSApp beginSheet:mEntryWindow modalForWindow:self.windowForSheet modalDelegate:self didEndSelector:@selector(cancelAction:returnCode:contextInfo:) contextInfo:@"entry"];
}
- (IBAction)startSource:(id)sender
{
    [dateField setDateValue:[NSDate date]];
	[NSApp beginSheet:mSourceWindow modalForWindow:self.windowForSheet modalDelegate:self didEndSelector:@selector(cancelAction:returnCode:contextInfo:) contextInfo:@"source"];
}

- (void)cancelAction:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}

- (NSString *)windowNibName
{
    return @"BMDDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    if ([self string] != nil) {
        [[textView textStorage] setAttributedString: [self string]];
    }
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL readSuccess = NO;
    NSAttributedString *fileContents = [[NSAttributedString alloc]
                                        initWithData:data options:NULL documentAttributes:NULL
                                        error:outError];
    
    if (fileContents) {
        readSuccess = YES;
        [self setString:fileContents];
        [fileContents release];
    }
    
    return readSuccess;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSData *data;
    
    [self setString:[textView textStorage]];
    NSMutableDictionary *dict = [NSDictionary dictionaryWithObject:NSRTFTextDocumentType forKey:NSDocumentTypeDocumentAttribute];
    
    [textView breakUndoCoalescing];
    
    data = [[self string] dataFromRange:NSMakeRange(0, [[self string] length]) documentAttributes:dict error:outError];
    
    return data;    
}

- (void) textDidChange: (NSNotification *) notification
{
    [self setString: [textView textStorage]];
}

- (void)sendText:(NSString*) aStr
{
    [[[textView textStorage] mutableString] appendString: aStr];
}

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification
{
    if ( [aNotification object] == msSurnameFld ) {
        if ( [msLockedBtn state] == NSOnState )
        {
            [self textFieldClosing:msSurnameFld];
            [msFirstnameFld becomeFirstResponder];
        }
    }
}
- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
    [self getMessage:aNotification];    
}

- (BOOL)textShouldBeginEditing:(NSNotification *)notification;
{
    [self controlTextDidBeginEditing:notification];
    return false;
}
- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [self getMessage:aNotification];
}


@end
