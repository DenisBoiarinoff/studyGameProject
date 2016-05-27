//
//  TaskManager.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 25.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;

@interface TaskManager : NSObject
//{
//	NSInteger* numberOfTasks;
//}

@property NSArray *taskArray;
@property NSNumber *numberOfTasks;
@property NSNumber *currentTask;

- (Task *) getTask;

- (void)enfOfInit;

- (void)notifyObserversAboutEndOfGame;

- (void)taskSolved:(NSNotification *)notification;

@end
