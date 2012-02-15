//
//  BMDDocument.m
//  BMD-X
//
//  Created by Steven Fuchs on 1/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BMDDocument.h"
#import "SpoiledTextField.h"
#import "NoSpaceTextField.h"

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
            mString     = [[NSAttributedString alloc] initWithString:@""];
            mNameBook   = [[NSMutableDictionary alloc] init];
            mMiddleNameOn = false;
            mSpare1On = false;
            mSpare2On = false;
            mSpare3On = false;
            mSpare4On = false;
            mFieldEditor = [[CSpoiledTextField alloc] init];
            [mFieldEditor setParentDoc:self];

            NSString* filPath = [[NSBundle mainBundle] pathForResource:@"BMDDIST" ofType:@"TXT"];
            NSString *filesContent = [[NSString alloc] initWithContentsOfFile:filPath];
            NSArray *lines = [filesContent componentsSeparatedByString:@"\n"];
            for(NSString *line in lines)
            {
                NSArray *lineElements = [line componentsSeparatedByString:@","];
                if ( [lineElements count] == 2 )
                    [mNameBook setObject:[lineElements objectAtIndex:1] forKey:[lineElements objectAtIndex:0]];
            }
        }    
    }
    return self;
}

- (void)spareFieldClosing:(id)fieldOb {
    if (fieldOb == msMiddleNameFld) {
        mMiddleNameOn = false;
        mSpare1On = false;
        mSpare2On = false;
        mSpare3On = false;
        mSpare4On = false;
        [msMiddleNameFld setStringValue:@""];
        [msMiddleNameFld setEnabled:false];
        [msSpareFld1 setStringValue:@""];
        [msSpareFld1 setEnabled:false];
        [msSpareFld2 setStringValue:@""];
        [msSpareFld2 setEnabled:false];
        [msSpareFld3 setStringValue:@""];
        [msSpareFld3 setEnabled:false];
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld1) {
        mSpare1On = false;
        mSpare2On = false;
        mSpare3On = false;
        mSpare4On = false;
        [msSpareFld1 setStringValue:@""];
        [msSpareFld1 setEnabled:false];
        [msSpareFld2 setStringValue:@""];
        [msSpareFld2 setEnabled:false];
        [msSpareFld3 setStringValue:@""];
        [msSpareFld3 setEnabled:false];
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld2) {
        mSpare2On = false;
        mSpare3On = false;
        mSpare4On = false;
        [msSpareFld2 setStringValue:@""];
        [msSpareFld2 setEnabled:false];
        [msSpareFld3 setStringValue:@""];
        [msSpareFld3 setEnabled:false];
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld3) {
        mSpare3On = false;
        mSpare4On = false;
        [msSpareFld3 setStringValue:@""];
        [msSpareFld3 setEnabled:false];
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld4) {
        mSpare4On = false;
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
}
- (void)spareFieldOpening:(id)fieldOb {
    if (fieldOb == msFirstnameFld) {        
        mMiddleNameOn = true;
        [msMiddleNameFld setEnabled:true];
        [self textFieldClosing:msFirstnameFld];
    }
    else if (fieldOb == msMiddleNameFld) {
        mSpare1On = true;
        [msSpareFld1 setEnabled:true];
        [self textFieldClosing:msMiddleNameFld];
    }
    else if (fieldOb == msSpareFld1) {
        mSpare2On = true;
        [msSpareFld2 setEnabled:true];
        [self textFieldClosing:msSpareFld1];
    }
    else if (fieldOb == msSpareFld2) {
        mSpare3On = true;
        [msSpareFld3 setEnabled:true];
        [self textFieldClosing:msSpareFld2];
    }
    else if (fieldOb == msSpareFld3) {
        mSpare4On = true;
        [msSpareFld4 setEnabled:true];
        [self textFieldClosing:msSpareFld3];
    }
}

- (void)textFieldClosing:(id)fieldOb
{    
    NSArray *lines = [[[textView textStorage] mutableString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
    
    BOOL    emptyLine = false;
    if ( lines.count == 0 || [[lines objectAtIndex:(lines.count - 1)] isEqualToString:@""] )
        emptyLine = true;

    if (fieldOb == msSurnameFld) {
        NSString*   surStr = [msSurnameFld stringValue];
        if ( [msCapsBtn state] == NSOnState )
            surStr = [surStr uppercaseString];
        if ( !emptyLine )
            surStr = [NSString stringWithFormat:@"\r%@", surStr];
        
        surStr = [NSString stringWithFormat:@"%@,", surStr];
        
        [self sendText:surStr];
        [mWindow makeFirstResponder:msFirstnameFld];
    }
    else if (fieldOb == msFirstnameFld) {        
        [self sendText:[NSString stringWithFormat:@"%@,", [msFirstnameFld stringValue]]];
        if ( mMiddleNameOn )
            [mWindow makeFirstResponder:msMiddleNameFld];
        else
            [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msMiddleNameFld) {
        [self sendText:[NSString stringWithFormat:@"%@,", [msMiddleNameFld stringValue]]];
        if ( mSpare1On )
            [mWindow makeFirstResponder:msSpareFld1];
        else
            [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld1) {
        [self sendText:[NSString stringWithFormat:@"%@,", [msSpareFld1 stringValue]]];
        if ( mSpare2On )
            [mWindow makeFirstResponder:msSpareFld2];
        else
            [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld2) {
        [self sendText:[NSString stringWithFormat:@"%@,", [msSpareFld2 stringValue]]];
        if ( mSpare3On )
            [mWindow makeFirstResponder:msSpareFld3];
        else
            [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld3) {
        [self sendText:[NSString stringWithFormat:@"%@,", [msSpareFld3 stringValue]]];
        if ( mSpare4On )
            [mWindow makeFirstResponder:msSpareFld4];
        else
            [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld4) {
        [self sendText:[NSString stringWithFormat:@"%@,", [msSpareFld4 stringValue]]];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msDistrictFld) {        
        [self sendText:[NSString stringWithFormat:@"%@,", [msDistrictFld stringValue]]];
        id val;
        if ( ( val = [mNameBook valueForKey:[msDistrictFld stringValue]] ) != NULL ) {
            [msVolumeFld setStringValue:val];
        }        
        [mWindow makeFirstResponder:msVolumeFld];
    }
    else if (fieldOb == msVolumeFld) {        
        [self sendText:[NSString stringWithFormat:@"%@,", [msVolumeFld stringValue]]];
        [mWindow makeFirstResponder:msPageFld];
    }
    else if (fieldOb == msPageFld){        
        [self sendText:[NSString stringWithFormat:@"%@\r", [msPageFld stringValue]]];
        if ( [msLockedBtn state] == NSOnState )
            [self textFieldClosing:msSurnameFld];
        else
            [mWindow makeFirstResponder:msSurnameFld];
    }
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)atextView doCommandBySelector:(SEL)command
{
    NSString* cmdStr = NSStringFromSelector(command);
    if ([cmdStr isEqualToString:@"insertNewline:"]) {
        [self textFieldClosing:control];
        return YES;
    }
    if ([cmdStr isEqualToString:@"enterTab:"]) {
        [self textFieldClosing:control];
        return YES;
    }
    if ([cmdStr isEqualToString:@"enterBackTab:"]) {
        [self textFieldUnClosing:control];
        return YES;
    }
    if ([cmdStr isEqualToString:@"insertTab:"]) {
        [self textFieldClosing:control];
        return YES;
    }
    if ([cmdStr isEqualToString:@"insertBacktab:"]) {
        [self textFieldUnClosing:control];
        return YES;
    }
    if ([cmdStr isEqualToString:@"selectNextKeyView:"]) {
        [self spareFieldClosing:control];
        return YES;
    }
    if ([cmdStr isEqualToString:@"doOpenSpare:"]) {
        [self spareFieldOpening:control];
        return YES;
    }
    return NO;
}

- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)client
{
    if ( [client isKindOfClass:[CNoSpaceTextField class]] ) {
        [mFieldEditor setEditorParent:client];
        return mFieldEditor;
    }
    return nil;
}

- (void)textFieldUnClosing:(id)fieldOb
{
    NSArray *lines = [[[textView textStorage] mutableString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
    
    if ( lines.count == 0 || [[lines objectAtIndex:(lines.count - 1)] isEqualToString:@""] ) {
        
    } else {
        NSString*   lastLine = [lines objectAtIndex:(lines.count - 1)];

        NSString* srcStr = @",";
        
        if (fieldOb == msSurnameFld) {
        }
        else if (fieldOb == msFirstnameFld) {        
            srcStr = [NSString stringWithFormat:@"%@,", [msSurnameFld stringValue]];
            [mWindow makeFirstResponder:msSurnameFld];
        }
        else if (fieldOb == msMiddleNameFld) {
            srcStr = [NSString stringWithFormat:@"%@,", [msFirstnameFld stringValue]];
            [mWindow makeFirstResponder:msFirstnameFld];
        }
        else if (fieldOb == msSpareFld1) {
            srcStr = [NSString stringWithFormat:@"%@,", [msMiddleNameFld stringValue]];
            [mWindow makeFirstResponder:msMiddleNameFld];
        }
        else if (fieldOb == msSpareFld2) {
            srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld1 stringValue]];
            [mWindow makeFirstResponder:msSpareFld1];
        }
        else if (fieldOb == msSpareFld3) {
            srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld2 stringValue]];
            [mWindow makeFirstResponder:msSpareFld2];
        }
        else if (fieldOb == msSpareFld4) {
            srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld3 stringValue]];
            [mWindow makeFirstResponder:msSpareFld3];
        }
        else if (fieldOb == msDistrictFld) {
            if ( mSpare4On ) {
                srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld4 stringValue]];
                [mWindow makeFirstResponder:msSpareFld4];
            } else if ( mSpare3On ) {
                srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld3 stringValue]];
                [mWindow makeFirstResponder:msSpareFld3];
            } else if ( mSpare2On ) {
                srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld2 stringValue]];
                [mWindow makeFirstResponder:msSpareFld2];
            } else if ( mSpare1On ) {
                srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld1 stringValue]];
                [mWindow makeFirstResponder:msSpareFld1];
            } else if ( mMiddleNameOn ) {
                srcStr = [NSString stringWithFormat:@"%@,", [msMiddleNameFld stringValue]];
                [mWindow makeFirstResponder:msMiddleNameFld];
            } else {
                srcStr = [NSString stringWithFormat:@"%@,", [msFirstnameFld stringValue]];
                [mWindow makeFirstResponder:msFirstnameFld];
            }
        }
        else if (fieldOb == msVolumeFld) {        
            srcStr = [NSString stringWithFormat:@"%@,", [msDistrictFld stringValue]];
            [mWindow makeFirstResponder:msDistrictFld];
        }
        else if (fieldOb == msPageFld){        
            srcStr = [NSString stringWithFormat:@"%@,", [msVolumeFld stringValue]];
            [mWindow makeFirstResponder:msVolumeFld];
        }
        long        contLength = [[[textView textStorage] mutableString] length];
        NSRange     comSpot = [lastLine rangeOfString:srcStr options:NSBackwardsSearch];
        if ( comSpot.location != NSNotFound ) {
            [[[textView textStorage] mutableString] replaceCharactersInRange:NSMakeRange( contLength - comSpot.length, comSpot.length ) withString:@""];
        }
    }
}

- (void)getMessage:(NSNotification *)aNotification
{
    
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

- (void)sendText:(NSString*) aStr
{
    [[[textView textStorage] mutableString] appendString: aStr];
}

-(NSArray*)keyValuesForString:(NSString*)stStr
{
    NSMutableArray*    answer = [NSMutableArray array];
    {
        for (NSString* key in mNameBook)    {
            if ( [key rangeOfString:stStr options:NSCaseInsensitiveSearch].location == 0 )
                [answer addObject:key];
        }
    }
    return answer;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return [[self keyValuesForString:[aComboBox stringValue]] objectAtIndex:index];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    id selText = [aComboBox stringValue];
    return [[self keyValuesForString:selText] count];
}

@end
