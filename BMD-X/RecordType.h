//
//  FormatType.h
//  BMD-X
//
//  Created by Steven Fuchs on 2/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    NO_TYPE = 0,
    BIRTH_TYPE = 1,
    DEATH_TYPE = 2,
    MARRAIGE_TYPE = 3
}RecordValues;

@interface CRecordType : NSObject {



@private
    
}
+ (RecordValues)recordTypeForTitle:(NSString*)titleString;

@end
