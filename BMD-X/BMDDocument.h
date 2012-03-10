//
//  BMDDocument.h
//  BMD-X
//
//  Created by Steven Fuchs on 1/18/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LockableText.h"

@class CSpoiledTextField;

@interface BMDDocument : NSDocument {

    IBOutlet	NSTextField*            msSurnameFld;
    IBOutlet	NSTextField*            msFirstnameFld;
    IBOutlet	NSComboBox*            msDistrictFld;
    IBOutlet	NSTextField*            msVolumeFld;
    IBOutlet	NSTextField*            msPageFld;
    IBOutlet	NSTextField*            msMiddleNameFld;
    IBOutlet	NSTextField*            msSpareFld1;
    IBOutlet	NSTextField*            msSpareFld2;
    IBOutlet	NSTextField*            msSpareFld3;
    IBOutlet	NSTextField*            msSpareFld4;
    Boolean mMiddleNameOn;
    Boolean mSpare1On;
    Boolean mSpare2On;
    Boolean mSpare3On;
    Boolean mSpare4On;
    
    IBOutlet	NSButton*               msLockedBtn;
    IBOutlet	NSButton*               msCapsBtn;

    IBOutlet	NSTextField*            pageFieldSolo;
    IBOutlet	NSTextField*            yearField;
    IBOutlet	NSTextField*			pageField;
    IBOutlet	NSTextField*			commentField;
    IBOutlet	NSPopUpButton*          formatMenu;
    IBOutlet	NSPopUpButton*          quarterMenu;
    IBOutlet	NSTextField*            rangeField;
    IBOutlet	NSTextField*			freeBMDRefField;
    IBOutlet	NSTextField*			locationField;
    IBOutlet	NSDatePicker*			dateField;
    
    
    IBOutlet	NSTextField*            emailField;
    IBOutlet	NSTextField*			passwordField;
    IBOutlet	NSPopUpButton*          orderMenu;
    IBOutlet	NSPopUpButton*          typeMenu;
    
    IBOutlet	NSPanel*				mPageWindow;
    IBOutlet	NSPanel*				mCommentWindow;
    IBOutlet	NSPanel*				mEntryWindow;
    IBOutlet	NSPanel*				mSourceWindow;
    IBOutlet    NSTextView*             textView;
    IBOutlet    NSWindow*             mWindow;
    
    NSAttributedString *mString;
    NSMutableDictionary *mNameBook;
    NSString*     lastTypedString;
    CSpoiledTextField*  mFieldEditor;
    BOOL mMarkedFlag;
    
@private
}
- (NSAttributedString *) string;
- (void)spareFieldOpening:(id)fieldOb;

- (void) setString: (NSAttributedString *) value;
- (void)textFieldClosing:(id)fieldOb;
- (void)textFieldUnClosing:(id)fieldOb;


- (IBAction)setSurNameLock:(id)sender;

- (IBAction)sendBreak:(id)sender;
- (IBAction)startPage:(id)sender;
- (IBAction)okPageDLOG:(id)sender;
- (IBAction)cancelPage:(id)sender;

- (IBAction)startComment:(id)sender;
- (IBAction)okCommentDLOG:(id)sender;
- (IBAction)cancelComment:(id)sender;


    - (IBAction)startEntry:(id)sender;
    - (IBAction)okEntryDLOG:(id)sender;
    - (IBAction)cancelEntry:(id)sender;

    - (IBAction)startSource:(id)sender;
    - (IBAction)okSourceDLOG:(id)sender;
    - (IBAction)cancelSource:(id)sender;

    - (IBAction)cancelAction:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;


@end