//
//  CFieldJumper.h
//  BMD-X
//
//  Created by Steven Fuchs on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecordType.h"

@class BMDDocument;
@class CNoSpaceAutoTextField;

typedef enum TYPE_EVENT
{
    TEXT_EVENT_NONE = 0,
    TEXT_EVENT_SURNAME = 1,
    TEXT_EVENT_FIRSTNAME = 2,
    TEXT_EVENT_MIDDLENAME = 3,
    TEXT_EVENT_MIDDLENAME_2 = 4,
    TEXT_EVENT_MIDDLENAME_3 = 5,
    TEXT_EVENT_MIDDLENAME_4 = 6,
    TEXT_EVENT_MIDDLENAME_5 = 7,
    TEXT_EVENT_DISTRICT = 8,
    TEXT_EVENT_MOTHER = 9,
    TEXT_EVENT_VOLUME = 10,
    TEXT_EVENT_PAGE = 11,
}EventTypes;

@interface CFieldJumper : NSObject
{
    

    
    
    
    NSTextField*            msSurnameFld;
    CNoSpaceAutoTextField*            msFirstnameFld;
    NSTextField*            msDistrictFld;
    NSTextField*            msVolumeFld;
    NSTextField*            msPageFld;
    CNoSpaceAutoTextField*            msMiddleNameFld;
    CNoSpaceAutoTextField*            msSpareFld1;
    CNoSpaceAutoTextField*            msSpareFld2;
    CNoSpaceAutoTextField*            msSpareFld3;
    CNoSpaceAutoTextField*            msSpareFld4;
    NSTextField*            msMotherSpouse;
    NSTextField*            msMotherSpouseLabel;
    NSTextField*            msDistrictLabel;

    
    NSWindow*            mWindow;

    
    
    int mYear;
    int mMonth;
    RecordValues mRecordType;
    
    Boolean mMiddleNameOn;
    Boolean mSpare1On;
    Boolean mSpare2On;
    Boolean mSpare3On;
    Boolean mSpare4On;

}
- (id)init:(BMDDocument*) parDoc;
-(EventTypes) actionForTextEvent:(id)fieldOb;
-(EventTypes) actionForTextCloseEvent:(id)fieldOb;
- (int)spareFieldClosing:(id)fieldOb;
- (int)spareFieldOpening:(id)fieldOb;
-(void)setQtr:(int)quarter andYear:(int)year;
-(void)setType:(RecordValues)type;
-(EventTypes) actionForTextField:(id)fieldOb;
-(void)clearFields;

@end
