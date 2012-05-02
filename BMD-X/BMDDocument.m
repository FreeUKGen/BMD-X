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
#import "CFieldJumper.h"
#import "RecordType.h"

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
            mString     = [[NSAttributedString alloc] initWithString:@""];
            mNameBook   = [[NSMutableDictionary alloc] init];
            mFirstNameBook   = [[NSMutableArray alloc] init];
            mMarkedFlag = false;
            mFieldEditor = [[CSpoiledTextField alloc] init];
            [mFieldEditor setParentDoc:self];

            [textView setUsesFontPanel:YES];
            NSStringEncoding theEnc;
            NSError *error;
        
            NSString* filPath = [[NSBundle mainBundle] pathForResource:@"BMDNAME" ofType:@"TXT"];
            NSString *filesContent = [[NSString alloc] initWithContentsOfFile:filPath usedEncoding:&theEnc error:&error];
            NSArray *lines = [filesContent componentsSeparatedByString:@"\n"];
            for(NSString *line in lines)
            {
                if (  ( ! [line isEqualToString:@""] ) && ( [line characterAtIndex:0] != ' ' ) )
                {
                    [mFirstNameBook addObject:[NSString stringWithString:line]];
                }
            }
        }    
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    mLineItem = [[CLineItem alloc] init];
    mJumper = [[CFieldJumper alloc] init:self];
}

- (void)spareFieldClosing:(id)fieldOb
{
    switch ( [mJumper spareFieldClosing:fieldOb] )
    {
        case ( TEXT_EVENT_MIDDLENAME ):
            break;
        case ( TEXT_EVENT_MIDDLENAME_2 ):
            break;
        case ( TEXT_EVENT_MIDDLENAME_3 ):
            break;
        case ( TEXT_EVENT_MIDDLENAME_4 ):
            break;
        case ( TEXT_EVENT_MIDDLENAME_5 ):
            break;
    }
}
    
- (void)spareFieldOpening:(id)fieldOb
{
    switch ( [mJumper spareFieldOpening:fieldOb] )
    {
        case ( TEXT_EVENT_FIRSTNAME ):
            mLineItem.firstName = [msFirstnameFld stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME ):
            mLineItem.middleName1 = [msMiddleNameFld stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_2 ):
            mLineItem.middleName2 = [msSpareFld1 stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_3 ):
            mLineItem.middleName3 = [msSpareFld2 stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_4 ):
            mLineItem.middleName4 = [msSpareFld3 stringValue];
            break;
    }
}

- (void)updateLine
{
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
    id val;

    if ( lines.count == 0 || [[lines objectAtIndex:(lines.count - 1)] isEqualToString:@""] )
        emptyLine = true;

    switch ( [mJumper actionForTextEvent:fieldOb] ) {
        case ( TEXT_EVENT_SURNAME ):
            mLineItem.lastName = ( [msCapsBtn state] == NSOnState ) ? [[msSurnameFld stringValue] uppercaseString] : [msSurnameFld stringValue];
            break;
        case ( TEXT_EVENT_FIRSTNAME ):
            mLineItem.firstName = [msFirstnameFld stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME ):
            if ( [[msMiddleNameFld stringValue] isEqualToString:@""] )
                [self spareFieldClosing:fieldOb];
            else
                mLineItem.middleName1 = [msMiddleNameFld stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_2 ):
            if ( [[msSpareFld1 stringValue] isEqualToString:@""] )
                [self spareFieldClosing:fieldOb];
            else
                mLineItem.middleName2 = [msSpareFld1 stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_3 ):
            if ( [[msSpareFld2 stringValue] isEqualToString:@""] )
                [self spareFieldClosing:fieldOb];
            else
                mLineItem.middleName3 = [msSpareFld2 stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_4 ):
            if ( [[msSpareFld3 stringValue] isEqualToString:@""] )
                [self spareFieldClosing:fieldOb];
            else
                mLineItem.middleName4 = [msSpareFld3 stringValue];
            break;
        case ( TEXT_EVENT_MIDDLENAME_5 ):
            if ( [[msSpareFld4 stringValue] isEqualToString:@""] )
                [self spareFieldClosing:fieldOb];
            else
                mLineItem.middleName5 = [msSpareFld4 stringValue];
            break;

        case ( TEXT_EVENT_MOTHER ):
            mLineItem.spouseName = [msMotherSpouse stringValue];
            break;

        case ( TEXT_EVENT_DISTRICT ):
            mLineItem.districtName = [msDistrictFld stringValue];
            if ( ( val = [mNameBook valueForKey:[msDistrictFld stringValue]] ) != NULL ) {
                [msVolumeFld setStringValue:val];
            }        
            break;
        case ( TEXT_EVENT_VOLUME ):
            mLineItem.volumeName = [msVolumeFld stringValue];
            break;
        case ( TEXT_EVENT_PAGE ):
            if ( [msLockedBtn state] == NSOnState )
                [self textFieldClosing:msSurnameFld];
            else
                [mWindow makeFirstResponder:msSurnameFld];

            mLineItem.pageName = [msPageFld stringValue];
            [mLineItem finalizeLine:true];

            break;

        default:
            break;
    }

    [self updateLine];
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)atextView doCommandBySelector:(SEL)command
{
    NSString* cmdStr = NSStringFromSelector(command);
    
//    NSLog( @"just got command:%@", cmdStr);

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
        
        switch ( [mJumper actionForTextCloseEvent:fieldOb] ) {
            case ( TEXT_EVENT_FIRSTNAME ):
                mLineItem.firstName = nil;
                break;
            case ( TEXT_EVENT_MIDDLENAME ):
                mLineItem.middleName1 = nil;
                break;
            case ( TEXT_EVENT_MIDDLENAME_2 ):
                mLineItem.middleName2 = nil;
                break;
            case ( TEXT_EVENT_MIDDLENAME_3 ):
                mLineItem.middleName3 = nil;
                break;
            case ( TEXT_EVENT_MIDDLENAME_4 ):
                mLineItem.middleName4 = nil;
                break;
            case ( TEXT_EVENT_MIDDLENAME_5 ):
                mLineItem.middleName5 = nil;
                break;
            case ( TEXT_EVENT_MOTHER ):
                mLineItem.spouseName = nil;
                break;
            case ( TEXT_EVENT_DISTRICT ):
                mLineItem.districtName = nil;
                break;
            case ( TEXT_EVENT_VOLUME ):
                mLineItem.volumeName = nil;
                break;
            case ( TEXT_EVENT_PAGE ):
                mLineItem.pageName = nil;
                break;
            case ( TEXT_EVENT_SURNAME ):
            case ( TEXT_EVENT_NONE ):
                break;
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

    [mJumper setQtr:[mEnteredMonth intValue] andYear:[mEnteredYear intValue]];
    [mLineItem setQtr:[mEnteredMonth intValue] andYear:[mEnteredYear intValue]];
    
    
    
    
    
    [mNameBook release];
    mNameBook   = [[NSMutableDictionary alloc] init];

    NSDate*     setDate = [NSDate dateWithString:[NSString localizedStringWithFormat:@"%@-%@-01 12:00:00 +0000", mEnteredYear, mEnteredMonth]];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(((start=nil) OR (start <= %@)) AND ((end=nil) OR (end >= %@)))", setDate, setDate];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"District" inManagedObjectContext:[mAppDelegate managedObjectContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    
    NSArray *fetchedObjects = [[mAppDelegate managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *info in fetchedObjects) {
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
    
    [mJumper setType:[CRecordType recordTypeForTitle:[[typeMenu selectedItem] title]]];
    [mLineItem setType:[CRecordType recordTypeForTitle:[[typeMenu selectedItem] title]]];
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

- (NSString *)getCompletionOf:(NSControl *)control
                        with:(NSString *)starter
                        indexOfSelectedItem:(NSUInteger)index
{
    NSMutableArray*    answerList = [NSMutableArray array];
    if ( control == msFirstnameFld ) {
        for (NSString* key in mFirstNameBook)    {
            if ( [key rangeOfString:starter options:NSCaseInsensitiveSearch].location == 0 )
                [answerList addObject:key];
        }
    }
    else if ( control == msDistrictFld ) {
        for (NSString* key in mNameBook)    {
            if ( [key rangeOfString:starter options:NSCaseInsensitiveSearch].location == 0 )
                [answerList addObject:key];
        }
    }

    if ( index < [answerList count] ) {
        NSString* answer = [answerList objectAtIndex:index];
        if ( control == msDistrictFld ) {
            NSString* val;
            if ( ( val = [mNameBook valueForKey:answer] ) != NULL ) {
                [msVolumeFld setStringValue:val];
            }        
        }
        return answer;
    }

    return NULL;
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
