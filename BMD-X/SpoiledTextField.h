//
//  SpoiledTextField.h
//  BMD-X
//
//  Created by Steven Fuchs on 2/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMDDocument.h"

@interface CSpoiledTextField : NSTextView {
    IBOutlet	BMDDocument*            mParentDoc;
    NSTextField* mFieldEditorsParent;

@private
    
}
-(void) setEditorParent:(NSTextField*)thePar;
-(void) setParentDoc:(BMDDocument*)thePar;



@end
