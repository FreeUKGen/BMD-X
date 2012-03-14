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
#import "FormatType.h"
#import "CQuaterMonth.h"
#import "CLineItem.h"

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
            mEnteredYear    = nil;
            mEnteredMonth   = nil;
            mLineItem = [[CLineItem alloc] init];
            mString     = [[NSAttributedString alloc] initWithString:@""];
            mNameBook   = [[NSMutableDictionary alloc] init];
            mFirstNameBook   = [[NSMutableArray alloc] init];
            mMiddleNameOn = false;
            mSpare1On = false;
            mSpare2On = false;
            mSpare3On = false;
            mSpare4On = false;
            mMarkedFlag = false;
            mFieldEditor = [[CSpoiledTextField alloc] init];
            [mFieldEditor setParentDoc:self];

            NSString* filPath = [[NSBundle mainBundle] pathForResource:@"BMDNAME" ofType:@"TXT"];
            NSString *filesContent = [[NSString alloc] initWithContentsOfFile:filPath];
            NSArray *lines = [filesContent componentsSeparatedByString:@"\n"];
            for(NSString *line in lines)
            {
                if (  ( ! [line isEqualToString:@""] ) && ( [line characterAtIndex:0] != ' ' ) )
                {
                    NSLog( @"added a given name:%@", line );
                    [mFirstNameBook addObject:[NSString stringWithString:line]];
                }
            }
        }    
    }
    return self;
}

//- (void)controlTextDidChange:(NSNotification *)note {
//    if ( [note object] == msFirstnameFld ) {
//        if( mAmDoingAutoComplete ){
//            return;
//        } else {
//            mAmDoingAutoComplete = YES;
//            [[[note userInfo] objectForKey:@"NSFieldEditor"] complete:nil];
//            mAmDoingAutoComplete = NO;
//        }
//    }
//}
//
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

- (void)updateLine
{
//    [[[textView textStorage] mutableString] deletLastLine];
    
//    [[[textView textStorage] mutableString] appendString: [mLineItem lineString]];
 //   [[[textView textStorage] mutableString] appendString: [mLineItem lineString]];
    mMarkedFlag = true;
    [mWindow setDocumentEdited:true];

    NSRange aRange = [[[textView textStorage] mutableString] rangeOfString:@"\r" options:NSBackwardsSearch];
    aRange.length = [[[textView textStorage] mutableString] length] - aRange.location;
    
    if ( aRange.location == NSNotFound )
    {
        aRange.location = 0;
        aRange.length = [[textView textStorage] length];
    }
    else
    {
        aRange.location += 1;
        aRange.length -= 1;
    }

    [[[textView textStorage] mutableString]replaceCharactersInRange:aRange withString:[mLineItem lineString]];
}


- (void)textFieldClosing:(id)fieldOb
{    
    NSArray *lines = [[[textView textStorage] mutableString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
    
    BOOL    emptyLine = false;
    if ( lines.count == 0 || [[lines objectAtIndex:(lines.count - 1)] isEqualToString:@""] )
        emptyLine = true;

    if (fieldOb == msSurnameFld) {
//        NSString*   surStr = [msSurnameFld stringValue];
//        if ( [msCapsBtn state] == NSOnState )
//            surStr = [surStr uppercaseString];
//        if ( !emptyLine )
//            surStr = [NSString stringWithFormat:@"\r%@", surStr];
//        
//        surStr = [NSString stringWithFormat:@"%@,", surStr];
//        
//        [self sendText:surStr];

        mLineItem.lastName = ( [msCapsBtn state] == NSOnState ) ? [[msSurnameFld stringValue] uppercaseString] : [msSurnameFld stringValue];
        [mWindow makeFirstResponder:msFirstnameFld];
    }
    else if (fieldOb == msFirstnameFld) {        
 //       [self sendText:[NSString stringWithFormat:@"%@ ", [msFirstnameFld stringValue]]];

        mLineItem.firstName = [msFirstnameFld stringValue];
        [mWindow makeFirstResponder:mMiddleNameOn ? msMiddleNameFld: msDistrictFld];
    }
    else if (fieldOb == msMiddleNameFld) {
 //       [self sendText:[NSString stringWithFormat:@"%@ ", [msMiddleNameFld stringValue]]];

        mLineItem.middleName1 = [msMiddleNameFld stringValue];
        [mWindow makeFirstResponder:mSpare1On ? msSpareFld1 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld1) {
   //     [self sendText:[NSString stringWithFormat:@"%@ ", [msSpareFld1 stringValue]]];

        mLineItem.middleName2 = [msSpareFld1 stringValue];
        [mWindow makeFirstResponder:mSpare2On ? msSpareFld2 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld2) {
//        [self sendText:[NSString stringWithFormat:@"%@ ", [msSpareFld2 stringValue]]];

        mLineItem.middleName3 = [msSpareFld2 stringValue];
        [mWindow makeFirstResponder:mSpare3On ? msSpareFld3 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld3) {
  //      [self sendText:[NSString stringWithFormat:@"%@ ", [msSpareFld3 stringValue]]];

        mLineItem.middleName4 = [msSpareFld3 stringValue];
        [mWindow makeFirstResponder: mSpare4On ? msSpareFld4 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld4) {
    //    [self sendText:[NSString stringWithFormat:@"%@ ", [msSpareFld4 stringValue]]];
        mLineItem.middleName5 = [msSpareFld4 stringValue];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msDistrictFld) {
//        NSString* srcStr;
//        long leng = [[[textView textStorage] mutableString] length];
//
//        if ( [[[textView textStorage] mutableString] characterAtIndex:leng - 1] != ',' )
//            srcStr = [NSString stringWithFormat:@",%@,", [msDistrictFld stringValue]];
//        else
//            srcStr = [NSString stringWithFormat:@"%@,", [msDistrictFld stringValue]];
//
//        [self sendText:[NSString stringWithFormat:@"%@", srcStr]];

        id val;

        mLineItem.districtName = [msDistrictFld stringValue];
        if ( ( val = [mNameBook valueForKey:[msDistrictFld stringValue]] ) != NULL ) {
            [msVolumeFld setStringValue:val];
        }        
        [mWindow makeFirstResponder:msVolumeFld];
    }
    else if (fieldOb == msVolumeFld) {        
 //       [self sendText:[NSString stringWithFormat:@"%@,", [msVolumeFld stringValue]]];
        mLineItem.volumeName = [msVolumeFld stringValue];
        [mWindow makeFirstResponder:msPageFld];
    }
    else if (fieldOb == msPageFld){        
//        [self sendText:[NSString stringWithFormat:@"%@\r", [msPageFld stringValue]]];
        mLineItem.pageName = [msPageFld stringValue];
        if ( [msLockedBtn state] == NSOnState )
            [self textFieldClosing:msSurnameFld];
        else
            [mWindow makeFirstResponder:msSurnameFld];
        [mLineItem finalizeLine:true];
    }
    else
        return;

    [self updateLine];
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
            srcStr = [NSString stringWithFormat:@"%@ ", [msFirstnameFld stringValue]];
            [mWindow makeFirstResponder:msFirstnameFld];
        }
        else if (fieldOb == msSpareFld1) {
            srcStr = [NSString stringWithFormat:@"%@ ", [msMiddleNameFld stringValue]];
            [mWindow makeFirstResponder:msMiddleNameFld];
        }
        else if (fieldOb == msSpareFld2) {
            srcStr = [NSString stringWithFormat:@"%@ ", [msSpareFld1 stringValue]];
            [mWindow makeFirstResponder:msSpareFld1];
        }
        else if (fieldOb == msSpareFld3) {
            srcStr = [NSString stringWithFormat:@"%@ ", [msSpareFld2 stringValue]];
            [mWindow makeFirstResponder:msSpareFld2];
        }
        else if (fieldOb == msSpareFld4) {
            srcStr = [NSString stringWithFormat:@"%@ ", [msSpareFld3 stringValue]];
            [mWindow makeFirstResponder:msSpareFld3];
        }
        else if (fieldOb == msDistrictFld) {
            long leng = [[[textView textStorage] mutableString] length];
            if ( [[[textView textStorage] mutableString] characterAtIndex:leng - 1] != ',' )
                srcStr = [NSString stringWithFormat:@",%@,", [msSpareFld4 stringValue]];
            else
                srcStr = [NSString stringWithFormat:@"%@,", [msSpareFld4 stringValue]];

            
            if ( mSpare4On ) {
                [mWindow makeFirstResponder:msSpareFld4];
            } else if ( mSpare3On ) {
                [mWindow makeFirstResponder:msSpareFld3];
            } else if ( mSpare2On ) {
                [mWindow makeFirstResponder:msSpareFld2];
            } else if ( mSpare1On ) {
                [mWindow makeFirstResponder:msSpareFld1];
            } else if ( mMiddleNameOn ) {
                [mWindow makeFirstResponder:msMiddleNameFld];
            } else {
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
    mMarkedFlag = false;
    [mWindow setDocumentEdited:false];
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

    NSString* formatCode = [CFormatType codeForTitle:[[formatMenu selectedItem] title]];
    NSMutableString* string = [NSMutableString stringWithFormat:@"+%@,%@,%@", formatCode, [yearField stringValue], [[quarterMenu selectedItem] title]];

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
    
    
    [mEnteredMonth release];
    [mEnteredYear release];
    mEnteredMonth           = [[NSString stringWithString:[CQuaterMonth monthForQuarter:[[quarterMenu selectedItem] title]]] retain];
    mEnteredYear           = [[NSString stringWithString:[yearField stringValue]] retain];

    [mNameBook release];
    mNameBook   = [[NSMutableDictionary alloc] init];

    NSDate*     setDate = [NSDate dateWithString:[NSString localizedStringWithFormat:@"%@-%@-01 12:00:00 +0000", mEnteredYear, mEnteredMonth]];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(((start=nil) OR (start <= %@)) AND ((end=nil) OR (end >= %@)))", setDate, setDate];
    NSLog(@"(((start=%@) OR (start <= %@)) AND ((end=%@) OR (end => %@)))", NULL, setDate, NULL, setDate);

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"District" inManagedObjectContext:[mAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[mAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        NSString* volHldr = @"";
        
        long    thisYear = [mEnteredYear intValue];
        
        if ( thisYear <= 1851 )
            volHldr = [info valueForKey:@"volume_1"];
        else if ( thisYear <= 1945 )
            volHldr = [info valueForKey:@"volume_2"];
        else if ( thisYear <= 1965 )
            volHldr = [info valueForKey:@"volume_3"];
        else if ( thisYear <= 1973 )
            volHldr = [info valueForKey:@"volume_4"];
        else
            volHldr = [info valueForKey:@"volume_5"];
        
        if ( volHldr != nil )
            [mNameBook setObject:[NSString stringWithString:volHldr] forKey:[NSString stringWithString:[info valueForKey:@"name"]]];
        else
            NSLog(@"missing volume number: %@", [info valueForKey:@"name"]);
    }

    [fetchRequest release];
    
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

- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index
{
    NSMutableArray*    answer = [NSMutableArray array];
    if ( control == msFirstnameFld ) {
        {
            NSString* stStr = [[control stringValue] substringWithRange:charRange]; 
            for (NSString* key in mFirstNameBook)    {
                if ( [key rangeOfString:stStr options:NSCaseInsensitiveSearch].location == 0 )
                    [answer addObject:key];
            }
        }
        *index = -1;
    }
    else if ( control == msDistrictFld ) {
        {
            NSString* stStr = [[control stringValue] substringWithRange:charRange]; 
            for (NSString* key in mNameBook)    {
                if ( [key rangeOfString:stStr options:NSCaseInsensitiveSearch].location == 0 )
                    [answer addObject:key];
            }
        }
        *index = -1;
    }
        
    return answer;    
}


- (BOOL)isDocumentEdited
{
    return mMarkedFlag;
}
- (void)sendText:(NSString*) aStr
{
    [[[textView textStorage] mutableString] appendString: aStr];
    mMarkedFlag = true;
    [mWindow setDocumentEdited:true];
}

@end
