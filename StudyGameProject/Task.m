//
//  Task.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 24.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "Task.h"

@implementation Task

//@synthesize question = _question;
//@synthesize answer = _answer;
//@synthesize question = _question;
//@synthesize answer = _answer;



- (id) init {
	return [self initWithQuestion:@"No Question" andAnswer:@"NO"];
}

- (id) initWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
	if (self = [super init]) {
		_question = question;
		_answer = answer;
		_isSolved = false;
	}
//	NSLog(@"form initWith ... question: %@ answer: %@", self.question, self.answer );
	return self;
}

-(id) initWithTask:(Task *)task {
	return [self initWithQuestion:task.question andAnswer:task.answer];
//	if (self = [super init]) {
//		_question = task.question;
//		_answer = task.answer;
//	}
//	return self;
}

- (bool) verifyAnswer:(NSString *) posibleAnswer{
	if ([_answer isEqualToString:posibleAnswer]) {
		_isSolved = TRUE;
		[self notifyObserversAboutSolving];
	}

	return _isSolved;
}

- (void)notifyObserversAboutSolving {
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"TaskIsSolved" object:self];
}

+ (Task *) taskWithQuestion:(NSString *)question andAnswer:(NSString *)answer {
//	NSLog(@"question: %@ and answer %@", question, answer);
	return [[Task alloc] initWithQuestion:question andAnswer:answer];
}

@end
