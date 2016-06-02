//
//  ViewCellStack.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 30.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ViewCellStack.h"

@interface ViewCellStack ()
@property (strong) NSMutableArray *data;
@end

@implementation ViewCellStack

-(id)init{
	if (self=[super init]){
		_data = [[NSMutableArray alloc] init];
		_count = 0;
	}
	return  self;
}

-(void)push:(id)anObject
{
	[self.data addObject:anObject];
	_count++;
}

-(id)pop{
	id obj = nil;
	if ([self.data count] > 0){
		obj = [self.data lastObject];
		[self.data removeLastObject];
		_count = self.data.count;
	}
	return obj;
}

-(void)clear{
	[self.data removeAllObjects];
	_count = 0;
}

-(id)lastObject{
	id obj = nil;
	if ([self.data count] > 0){
		obj = [self.data lastObject];
	}
	return obj;
}

@end