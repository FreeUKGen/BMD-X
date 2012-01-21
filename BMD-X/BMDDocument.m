//
//  BMDDocument.m
//  BMD-X
//
//  Created by Steven Fuchs on 1/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BMDDocument.h"

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



- (NSAttributedString *) string { return [[mString retain] autorelease]; }



- (void) setString: (NSAttributedString *) newValue {
    
    if (mString != newValue) {
        
        if (mString) [mString release];
        
        mString = [newValue copy];
        
    }
    
}
- (IBAction)sendBreak:(id)sender {
    NSString* string = [NSString stringWithFormat:@"+BREAK\r", [pageFieldSolo stringValue]];
    
    [[[textView textStorage] mutableString] appendString: string];
}

- (IBAction)startPage:(id)sender{
    [NSApp beginSheet:mPageWindow modalForWindow:self.windowForSheet modalDelegate:self didEndSelector:@selector(cancelAction:returnCode:contextInfo:) contextInfo:@"entry"];
}

- (IBAction)okPageDLOG:(id)sender{
    NSString* string = [NSString stringWithFormat:@"+PAGE,%@\r", [pageFieldSolo stringValue]];
    
    [[[textView textStorage] mutableString] appendString: string];
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




- (IBAction)okSourceDLOG:(id)sender;
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
    
    
    [[[textView textStorage] mutableString] appendString: string];
    
    [NSApp endSheet:mSourceWindow returnCode:[sender tag]];
}
- (IBAction)okEntryDLOG:(id)sender
{
    NSString* string = [NSString stringWithFormat:@"+INFO,%@,%@,%@,%@,macintosh\r", [emailField stringValue], [passwordField stringValue], [[orderMenu selectedItem] title], [[typeMenu selectedItem] title] ];
    
    [[[textView textStorage] mutableString] appendString: string];
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
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"BMDDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    if ([self string] != nil) {
        
        [[textView textStorage] setAttributedString: [self string]];
        
    }}

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
    
    NSMutableDictionary *dict = [NSDictionary dictionaryWithObject:NSRTFTextDocumentType
                                 
                                                            forKey:NSDocumentTypeDocumentAttribute];
    
    [textView breakUndoCoalescing];
    
    data = [[self string] dataFromRange:NSMakeRange(0, [[self string] length])
            
                     documentAttributes:dict error:outError];
    
    return data;
    
}
- (void) textDidChange: (NSNotification *) notification
{
    [self setString: [textView textStorage]];
}
@end
