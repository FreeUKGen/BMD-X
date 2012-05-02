//
//  FormatType.m
//  BMD-X
//
//  Created by Steven Fuchs on 2/16/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordType.h"


@implementation CRecordType

+ (RecordValues)recordTypeForTitle:(NSString*)titleString
{
    if ( [titleString isEqualToString:@"BIRTHS"] ) {
        return BIRTH_TYPE;
    } else if ( [titleString isEqualToString:@"MARRAIGES"] ) {
        return MARRAIGE_TYPE;
    } else if ( [titleString isEqualToString:@"DEATHS"] ) {
        return DEATH_TYPE;
    }
    
    return BIRTH_TYPE;
}



- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
