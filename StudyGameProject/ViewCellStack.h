//
//  NSObject_ViewCellStack.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 30.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewCellStack : NSObject

@property (assign,readonly) long count;

-(void)push:(id)anObject;
-(id)pop;
-(void)clear;
-(id)lastObject;

@end
