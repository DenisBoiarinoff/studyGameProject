//
//  Task.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 24.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
//{
//	NSString *_question;
//	NSString *_answer;
//}


@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *answer;

@property BOOL isSolved;

+ (Task *) taskWithQuestion:(NSString *)question andAnswer:(NSString *)answer;

- (id) initWithQuestion:(NSString *)question andAnswer:(NSString *)answer;
- (id) initWithTask:(Task *)task;

- (bool) verifyAnswer:(NSString *) posibleAnswer;

- (void)notifyObserversAboutSolving;
//-(NSInteger) getAnswerLength;

@end
