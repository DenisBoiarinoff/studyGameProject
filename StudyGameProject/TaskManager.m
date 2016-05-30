//
//  TaskManager.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 25.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "TaskManager.h"

#import "Task.h"

@implementation TaskManager

@synthesize taskArray;
//@synthesize numberOfTasks = _numberOfTasks;


-(Task *) getTask {
	if (!taskArray) {
		[self initTaskArray];
	}
	if ([self.currentTask intValue] < [self.numberOfTasks intValue]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskSolved:)
													 name:@"TaskIsSolved"
												   object:[taskArray objectAtIndex:[self.currentTask intValue]]];
		return [taskArray objectAtIndex:[self.currentTask intValue]];

	} else {
		[self notifyObserversAboutEndOfGame];
		return nil;
	}

}

- (void)notifyObserversAboutEndOfGame {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"TasksIsFinish" object:self];
}

- (void)taskSolved:(NSNotification *)notification {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	int num = [self.currentTask intValue];
	num++;
	self.currentTask = [NSNumber numberWithInt:num];
}

- (void) initTaskArray {
	Task *task1 = [Task taskWithQuestion:@"Task 1" andAnswer:@"123"];
	Task *task2 = [[Task alloc] init];
	Task *task3 = [[Task alloc] init];
	[task3 setQuestion:@"Task 3"];
	[task3 setAnswer:@"3"];
	Task *task4 = [Task taskWithQuestion:@"Task 4" andAnswer:@"4444"];
	taskArray = [[NSArray alloc] initWithObjects:task1, task2, task3, task4, nil];
	self.numberOfTasks = [NSNumber numberWithLong:[taskArray count]];
	self.currentTask = [NSNumber numberWithInt:0];
//	[self.numberOfTasks setNumberOfTasks:[taskArray count]];
//	NSLog(@"number of task: %ld", [taskArray count]);
//	[taskArray initWithObjects:task1, task2, task3, task4, nil];
//	NSLog(@"number of task: %ld", [taskArray count]);
	[self enfOfInit];
}

- (void)enfOfInit {

	NSLog(@"enfOfInit");
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:@"enfOfInitNotification" object:self];

}

@end
