//
//  CFieldJumper.m
//  BMD-X
//
//  Created by Steven Fuchs on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CFieldJumper.h"
#import "BMDDocument.h"

@implementation CFieldJumper



- (id)init:(BMDDocument*) parDoc
{
    self = [super init];
    if (self) {
        mMiddleNameOn = false;
        mSpare1On = false;
        mSpare2On = false;
        mSpare3On = false;
        mSpare4On = false;
        
        if ( parDoc ) {
            
            msSurnameFld = parDoc->msSurnameFld;
            msFirstnameFld = parDoc->msFirstnameFld;
            msDistrictFld = parDoc->msDistrictFld;
            msVolumeFld = parDoc->msVolumeFld;
            msPageFld = parDoc->msPageFld;
            msMiddleNameFld = parDoc->msMiddleNameFld;
            msSpareFld1 = parDoc->msSpareFld1;
            msSpareFld2 = parDoc->msSpareFld2;
            msSpareFld3 = parDoc->msSpareFld3;
            msSpareFld4 = parDoc->msSpareFld4;
            mWindow = parDoc->mWindow;
            
        }
    }
    return self;
}

-(void)setQtr:(int)quarter andYear:(int)year
{
    
}

-(int) actionForTextCloseEvent:(id)fieldOb
{
    int answer = TEXT_EVENT_NONE;

    if (fieldOb == msFirstnameFld) {        
        answer = TEXT_EVENT_FIRSTNAME;
        [mWindow makeFirstResponder:msSurnameFld];
    }
    else if (fieldOb == msMiddleNameFld) {
        answer = TEXT_EVENT_MIDDLENAME;
        [mWindow makeFirstResponder:msFirstnameFld];
    }
    else if (fieldOb == msSpareFld1) {
        answer = TEXT_EVENT_MIDDLENAME_2;
        [mWindow makeFirstResponder:msMiddleNameFld];
    }
    else if (fieldOb == msSpareFld2) {
        answer = TEXT_EVENT_MIDDLENAME_3;
        [mWindow makeFirstResponder:msSpareFld1];
    }
    else if (fieldOb == msSpareFld3) {
        answer = TEXT_EVENT_MIDDLENAME_4;
        [mWindow makeFirstResponder: msSpareFld2];
    }
    else if (fieldOb == msSpareFld4) {
        answer = TEXT_EVENT_MIDDLENAME_5;
        [mWindow makeFirstResponder:msSpareFld3];
    }
    else if (fieldOb == msDistrictFld) {        
        answer = TEXT_EVENT_DISTRICT;
        
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
        answer = TEXT_EVENT_VOLUME;
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msPageFld){        
        answer = TEXT_EVENT_PAGE;
        [mWindow makeFirstResponder:msVolumeFld];
    }

   return answer;
}

-(int) actionForTextEvent:(id)fieldOb
{
    int answer = TEXT_EVENT_NONE;
    
    if (fieldOb == msSurnameFld) {
        answer = TEXT_EVENT_SURNAME;
        [mWindow makeFirstResponder:msFirstnameFld];
    }
    else if (fieldOb == msFirstnameFld) {        
        answer = TEXT_EVENT_FIRSTNAME;
        [mWindow makeFirstResponder:mMiddleNameOn ? msMiddleNameFld: msDistrictFld];
    }
    else if (fieldOb == msMiddleNameFld) {
        answer = TEXT_EVENT_MIDDLENAME;
        [mWindow makeFirstResponder:mSpare1On ? msSpareFld1 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld1) {
        answer = TEXT_EVENT_MIDDLENAME_2;
        [mWindow makeFirstResponder:mSpare2On ? msSpareFld2 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld2) {
        answer = TEXT_EVENT_MIDDLENAME_3;
        [mWindow makeFirstResponder:mSpare3On ? msSpareFld3 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld3) {
        answer = TEXT_EVENT_MIDDLENAME_4;
        [mWindow makeFirstResponder: mSpare4On ? msSpareFld4 : msDistrictFld];
    }
    else if (fieldOb == msSpareFld4) {
        answer = TEXT_EVENT_MIDDLENAME_5;
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msDistrictFld) {        
        answer = TEXT_EVENT_DISTRICT;

        [mWindow makeFirstResponder:msVolumeFld];
    }
    else if (fieldOb == msVolumeFld) {        
        answer = TEXT_EVENT_VOLUME;
        [mWindow makeFirstResponder:msPageFld];
    }
    else if (fieldOb == msPageFld){        
        answer = TEXT_EVENT_PAGE;
        [mWindow makeFirstResponder:msSurnameFld];
    }
    return answer;
}

- (int)spareFieldClosing:(id)fieldOb {
    int answer = TEXT_EVENT_NONE;
    if (fieldOb == msMiddleNameFld) {
        answer = TEXT_EVENT_MIDDLENAME;
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
        answer = TEXT_EVENT_MIDDLENAME_2;
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
        answer = TEXT_EVENT_MIDDLENAME_3;
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
        answer = TEXT_EVENT_MIDDLENAME_4;
        mSpare3On = false;
        mSpare4On = false;
        [msSpareFld3 setStringValue:@""];
        [msSpareFld3 setEnabled:false];
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    else if (fieldOb == msSpareFld4) {
        answer = TEXT_EVENT_MIDDLENAME_5;
        mSpare4On = false;
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:msDistrictFld];
    }
    return answer;
}
- (int)spareFieldOpening:(id)fieldOb {
    int answer = TEXT_EVENT_NONE;
    if (fieldOb == msFirstnameFld) {        
        answer = TEXT_EVENT_FIRSTNAME;
        mMiddleNameOn = true;
        [msMiddleNameFld setEnabled:true];
        [mWindow makeFirstResponder:msMiddleNameFld];
    }
    else if (fieldOb == msMiddleNameFld) {
        answer = TEXT_EVENT_MIDDLENAME;
        mSpare1On = true;
        [msSpareFld1 setEnabled:true];
        [mWindow makeFirstResponder:msSpareFld1];
    }
    else if (fieldOb == msSpareFld1) {
        answer = TEXT_EVENT_MIDDLENAME_2;
        mSpare2On = true;
        [msSpareFld2 setEnabled:true];
        [mWindow makeFirstResponder:msSpareFld2];
    }
    else if (fieldOb == msSpareFld2) {
        answer = TEXT_EVENT_MIDDLENAME_3;
        mSpare3On = true;
        [msSpareFld3 setEnabled:true];
        [mWindow makeFirstResponder:msSpareFld3];
    }
    else if (fieldOb == msSpareFld3) {
        answer = TEXT_EVENT_MIDDLENAME_4;
        mSpare4On = true;
        [msSpareFld4 setEnabled:true];
        [mWindow makeFirstResponder:msSpareFld4];
    }
    return answer;
}

@end
