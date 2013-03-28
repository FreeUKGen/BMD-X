//
//  CFieldJumper.m
//  BMD-X
//
//  Created by Steven Fuchs on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CFieldJumper.h"
#import "BMDDocument.h"
#import "RecordType.h"
#import "CNoSpaceAutoTextField.h"

@interface CFieldJumper (internals)
    - (BOOL) isModern;
    - (void) adjustFields;

@end


@implementation CFieldJumper

#define ADJ_SIZE 200


- (id)init:(BMDDocument*) parDoc
{
    self = [super init];
    if (self) {
        mMiddleNameOn = false;
        mSpare1On = false;
        mSpare2On = false;
        mSpare3On = false;
        mSpare4On = false;
        mRecordType = BIRTH_TYPE;
        mYear = 1900;
        mMonth = 1;
        
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
            msMotherSpouse = parDoc->msMotherSpouse;
            msMotherSpouseLabel = parDoc->msMotherSpouseLabel;
            msDistrictLabel = parDoc->msDistrictLabel;
            mWindow = parDoc->mWindow;
            
            [self adjustFields];
            
        }
    }
    return self;
}

-(void)clearFields
{
    [msFirstnameFld setStringValue:@""];
    [msMiddleNameFld setStringValue:@""];
    [msSpareFld1 setStringValue:@""];
    [msSpareFld2 setStringValue:@""];
    [msSpareFld3 setStringValue:@""];
    [msSpareFld4 setStringValue:@""];
    [msMotherSpouse setStringValue:@""];
    [msDistrictFld setStringValue:@""];
    [msVolumeFld setStringValue:@""];
    [msPageFld setStringValue:@""];
}

-(void)adjustFields
{
    NSRect distBounds = [msDistrictFld frame];
    NSRect labelBnds = [msDistrictLabel frame];
    if ( [self isModern] ) {
        if ( mRecordType == BIRTH_TYPE )
            [msMotherSpouseLabel setStringValue:@"Mother"];
        else if ( mRecordType == MARRAIGE_TYPE )
            [msMotherSpouseLabel setStringValue:@"Spouse"];
        else if ( mRecordType == DEATH_TYPE )
        {
            if ( ( mYear >= 1970 ) || ( ( mYear == 1969 ) && ( mMonth >= 6 ) ) )
                [msMotherSpouseLabel setStringValue:@"Date of Birth"];
            else
                [msMotherSpouseLabel setStringValue:@"Age"];
        }
        [msMotherSpouse setHidden:false];
        [msMotherSpouseLabel setHidden:false];

        if ( distBounds.size.width > ADJ_SIZE )
        {
            distBounds.origin.x += ADJ_SIZE;
            labelBnds.origin.x += ADJ_SIZE;
            distBounds.size.width -= ADJ_SIZE;
            [msDistrictFld setFrame:distBounds];
            [msDistrictLabel setFrame:labelBnds];
        }
    }
    else
    {
        [msMotherSpouse setHidden:true];
        [msMotherSpouseLabel setHidden:true];
        if ( distBounds.size.width < ADJ_SIZE )
        {
            distBounds.origin.x -= ADJ_SIZE;
            labelBnds.origin.x -= ADJ_SIZE;
            distBounds.size.width += ADJ_SIZE;
            [msDistrictFld setFrame:distBounds];
            [msDistrictLabel setFrame:labelBnds];
        }
    }
}

-(void)setQtr:(int)quarter andYear:(int)year
{
    mYear = year;
    mMonth = quarter;
    
    [self adjustFields];
}

-(void)setType:(RecordValues)type
{
    mRecordType = type;

    [self adjustFields];
}

-(BOOL)isModern
{
    BOOL answer = false;
    if ( mRecordType == BIRTH_TYPE )
        answer =( ( mYear >= 1912 ) || ( ( mYear == 1911 ) && ( mMonth >= 9 ) ) );
    else if ( mRecordType == MARRAIGE_TYPE )
        answer =( ( mYear >= 1913 ) || ( ( mYear == 1912 ) && ( mMonth >= 3 ) ) );
    else if ( mRecordType == DEATH_TYPE )
        answer =( mYear >= 1866 );
    
    return answer;
}


-(EventTypes) actionForTextField:(id)fieldOb
{
    EventTypes answer = TEXT_EVENT_NONE;
    
    if (fieldOb == msFirstnameFld) {        
        answer = TEXT_EVENT_FIRSTNAME;
    }
    else if (fieldOb == msMiddleNameFld) {
        answer = TEXT_EVENT_MIDDLENAME;
    }
    else if (fieldOb == msSpareFld1) {
        answer = TEXT_EVENT_MIDDLENAME_2;
    }
    else if (fieldOb == msSpareFld2) {
        answer = TEXT_EVENT_MIDDLENAME_3;
    }
    else if (fieldOb == msSpareFld3) {
        answer = TEXT_EVENT_MIDDLENAME_4;
    }
    else if (fieldOb == msSpareFld4) {
        answer = TEXT_EVENT_MIDDLENAME_5;
    }
    else if (fieldOb == msMotherSpouse) {
        if ( [self isModern] )
        {
            answer = TEXT_EVENT_MOTHER;
        }
    }
    else if (fieldOb == msDistrictFld) {        
        answer = TEXT_EVENT_DISTRICT;
    }
    else if (fieldOb == msVolumeFld) {        
        answer = TEXT_EVENT_VOLUME;
    }
    else if (fieldOb == msPageFld){        
        answer = TEXT_EVENT_PAGE;
    }
    
    return answer;
}
-(EventTypes) actionForTextCloseEvent:(id)fieldOb
{
    EventTypes answer = TEXT_EVENT_NONE;
    
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
    else if (fieldOb == msMotherSpouse) {
        if ( [self isModern] )
        {
            answer = TEXT_EVENT_MOTHER;
            
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
    }
    else if (fieldOb == msDistrictFld) {        
        answer = TEXT_EVENT_DISTRICT;
        if ( [self isModern] )
        {
            [mWindow makeFirstResponder:msMotherSpouse];
        }
        else
        {
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

-(EventTypes) actionForTextEvent:(id)fieldOb
{
    EventTypes answer = TEXT_EVENT_NONE;
    
    if (fieldOb == msSurnameFld) {
        answer = TEXT_EVENT_SURNAME;
        [mWindow makeFirstResponder:msFirstnameFld];
    }
    else if (fieldOb == msFirstnameFld) {        
        answer = TEXT_EVENT_FIRSTNAME;
        [mWindow makeFirstResponder:mMiddleNameOn ? msMiddleNameFld: ( [self isModern] ? msMotherSpouse : msDistrictFld )];
    }
    else if (fieldOb == msMiddleNameFld) {
        answer = TEXT_EVENT_MIDDLENAME;
        [mWindow makeFirstResponder:mSpare1On ? msSpareFld1 : ( [self isModern] ? msMotherSpouse : msDistrictFld )];
    }
    else if (fieldOb == msSpareFld1) {
        answer = TEXT_EVENT_MIDDLENAME_2;
        [mWindow makeFirstResponder:mSpare2On ? msSpareFld2 : ( [self isModern] ? msMotherSpouse : msDistrictFld )];
    }
    else if (fieldOb == msSpareFld2) {
        answer = TEXT_EVENT_MIDDLENAME_3;
        [mWindow makeFirstResponder:mSpare3On ? msSpareFld3 : ( [self isModern] ? msMotherSpouse : msDistrictFld )];
    }
    else if (fieldOb == msSpareFld3) {
        answer = TEXT_EVENT_MIDDLENAME_4;
        [mWindow makeFirstResponder: mSpare4On ? msSpareFld4 : ( [self isModern] ? msMotherSpouse : msDistrictFld )];
    }
    else if (fieldOb == msSpareFld4) {
        answer = TEXT_EVENT_MIDDLENAME_5;
        [mWindow makeFirstResponder:( [self isModern] ? msMotherSpouse : msDistrictFld )];
    }
     else if (fieldOb == msMotherSpouse) {        
         answer = TEXT_EVENT_MOTHER;
         
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
        [mWindow makeFirstResponder:([self isModern] ? msMotherSpouse : msDistrictFld)];
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
        [mWindow makeFirstResponder:([self isModern] ? msMotherSpouse : msDistrictFld)];
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
        [mWindow makeFirstResponder:([self isModern] ? msMotherSpouse : msDistrictFld)];
    }
    else if (fieldOb == msSpareFld3) {
        answer = TEXT_EVENT_MIDDLENAME_4;
        mSpare3On = false;
        mSpare4On = false;
        [msSpareFld3 setStringValue:@""];
        [msSpareFld3 setEnabled:false];
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:([self isModern] ? msMotherSpouse : msDistrictFld)];
    }
    else if (fieldOb == msSpareFld4) {
        answer = TEXT_EVENT_MIDDLENAME_5;
        mSpare4On = false;
        [msSpareFld4 setStringValue:@""];
        [msSpareFld4 setEnabled:false];
        [mWindow makeFirstResponder:([self isModern] ? msMotherSpouse : msDistrictFld)];
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
        [msMiddleNameFld setIgnoreKeyUp:true];
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
