//
//  CFieldJumper.h
//  BMD-X
//
//  Created by Steven Fuchs on 3/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMDDocument;

@interface CFieldJumper : NSObject
{
    enum TYPE_EVENT
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
        TEXT_EVENT_VOLUME = 9,
        TEXT_EVENT_PAGE = 10,
    };
    
    

    
    
    
    NSTextField*            msSurnameFld;
    NSTextField*            msFirstnameFld;
    NSTextField*            msDistrictFld;
    NSTextField*            msVolumeFld;
    NSTextField*            msPageFld;
    NSTextField*            msMiddleNameFld;
    NSTextField*            msSpareFld1;
    NSTextField*            msSpareFld2;
    NSTextField*            msSpareFld3;
    NSTextField*            msSpareFld4;
    
    
    NSWindow*            mWindow;

    
    
    
    
    
    Boolean mMiddleNameOn;
    Boolean mSpare1On;
    Boolean mSpare2On;
    Boolean mSpare3On;
    Boolean mSpare4On;

}
- (id)init:(BMDDocument*) parDoc;
-(int) actionForTextEvent:(id)fieldOb;
-(int) actionForTextCloseEvent:(id)fieldOb;
- (int)spareFieldClosing:(id)fieldOb;
- (int)spareFieldOpening:(id)fieldOb;
-(void)setQtr:(int)quarter andYear:(int)year;

@end
