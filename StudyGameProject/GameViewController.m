//
//  GameViewController.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 23.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "GameViewController.h"
#import "LetterCollectionViewCell.h"
#import "Task.h"
#import "TaskManager.h"
#import "UIColor+ColorFromHex.h"

@interface GameViewController ()

@property TaskManager *taskManger;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property Task *currentTask;

@property NSString *answerString;

@property NSMutableString *possibleAnswer;

@end

@implementation GameViewController

static NSString *cellIdentifier = @"LatterCollectionViewCell";

- (void)viewDidLoad {
	[super viewDidLoad];

	self.lettersCellCollectionView.backgroundColor =  [UIColor colorwithHexString:@"FFFFFF" alpha:0];
	
//	[self placingItems];
	// Do any additional setup after loading the view from its nib.

	[self.lettersCellCollectionView registerClass:[LetterCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];

	self.taskManger = [[TaskManager alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(gameIsEnded:)
												 name:@"TasksIsFinish"
											   object:self.taskManger];

	self.currentTask = nil;
	self.possibleAnswer = [[NSMutableString alloc] init];

	self.dataArray = [[NSMutableArray alloc] initWithCapacity:12];
	for (int i = 0; i < 12; i++) {
		[self.dataArray addObject:@"1"];
	}

	[self.lettersCellCollectionView setScrollEnabled:false];
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	[self reloadTask];
	[self reloadSubview];

}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Collection view data source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.dataArray count];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	/* Uncomment this block to use subclass-based cells */
	LetterCollectionViewCell *cell = (LetterCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
																										   forIndexPath:indexPath];
	[cell setHidden:NO];
	[cell.letter setText:[self.dataArray objectAtIndex:indexPath.row]];
	//	NSString *cellData = [self.dataArray objectAtIndex:indexPath.row];
/* end of subclass-based cells block */
	// Return the cell
	return cell;

}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	LetterCollectionViewCell *cell = (LetterCollectionViewCell *)[self.lettersCellCollectionView cellForItemAtIndexPath:indexPath];
//	NSLog(@"cell text: %@", [cell.letter text]);
	if (cell) {
		NSMutableString *selectedLetter = [[NSMutableString alloc] initWithString:[cell.letter text]];
		self.possibleAnswer = [[self.possibleAnswer  stringByAppendingString:selectedLetter] mutableCopy];

		[cell setHidden:YES];
		[self answerStringIsChanged];
		//		[self isItAnswer];
		//		[(UIButton *)[self.answerCellStackView viewWithTag:10] setTitle:[cell.letter text] forState:UIControlStateNormal];
		//		NSLog(@"cell text: %@", [cell.letter text]);

		//		[(UILabel *)[self.answerCellStackView viewWithTag:10] setText:[cell.letter text]];

	}
	//	NSLog(@"Did select item: %@", [self.lettersCellCollectionView cellForItemAtIndexPath:indexPath] );
	//	NSLog(@"Did select item: %ld", indexPath.row);
	
}

- (void)taskWasSolved:(NSNotification *)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"TaskIsSolved" object:nil];
	self.currentTask = nil;

	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"LeveL Complited"
										  message:@"Well done! You guessed thew word and received 10 coins!"
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Next Level"
														  style:UIAlertActionStyleDefault
														handler:^(UIAlertAction * action) {
															[self reloadTask];
														}]; // 2

	[alertController addAction:firstAction];

	[self presentViewController:alertController animated:YES completion:nil];
}



- (void)gameIsEnded:(NSNotification *)notification {

	NSString *greeting = [[NSString alloc] initWithFormat:@"game is over!" ];

	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Sorry!!!"
										  message:greeting
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Back to Menu"
														  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
															  [self.navigationController popViewControllerAnimated:YES];
														  }]; // 2

	[alertController addAction:firstAction];

	[self presentViewController:alertController animated:YES completion:nil];

}

- (void) reloadTask {

	if(!self.currentTask) {
		self.currentTask = [self.taskManger getTask];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskWasSolved:)
													 name:@"TaskIsSolved"
												   object:self.currentTask];
		[self reloadSubview];
	}

	NSArray *letterList = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0",
						   @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
						   @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
						   @"U", @"V", @"W", @"X", @"Y", @"Z", nil];

	[self.questionLabel setText:self.currentTask.question];
	NSString *answer = self.currentTask.answer;

	for (int i = 0; i < 12; i++) {
		NSInteger rundInt = rand() % 35;
		NSString *str = [letterList objectAtIndex:rundInt];
		[self.dataArray replaceObjectAtIndex:i withObject:str];
	}
	NSMutableArray *array = [[NSMutableArray alloc] init];
	while ([answer length] != [array count]) {
		NSInteger rundInt = rand() % 11;
		NSNumber *num = [NSNumber numberWithInteger:rundInt];
		NSInteger location = [array indexOfObject:num];
		if (location == NSNotFound) {
			[array addObject:num];
			[self.dataArray replaceObjectAtIndex:rundInt
									  withObject:[NSString stringWithFormat:@"%c", [answer characterAtIndex:[array count] - 1]]];
		}
	}

	//	if (self.currentTask) {
	//
	//		for (int i = 0; i < [answer length]; i++) {
	////			NSLog(@"%@", [NSString stringWithFormat:@"%c", [answer characterAtIndex:i]]);
	//			NSInteger rundInt = rand() % 11;
	//			NSNumber *num = [NSNumber numberWithInteger:rundInt];
	//			NSInteger location = [array indexOfObject:num];
	//			if (location == NSNotFound) {
	//
	//			}
	////			NSLog(@"%ld", rundInt);
	//			[self.dataArray replaceObjectAtIndex:rundInt
	//									  withObject:[NSString stringWithFormat:@"%c", [answer characterAtIndex:i]]];
	//
	//		}
	//	}
	[self.lettersCellCollectionView reloadData];
}

- (void) reloadSubview {
	for(UIView *subview in [self.answerCellStackView subviews]) {
		if (subview.class != self.backgroundImage.class) {
			[subview removeFromSuperview];
		}
//		[subview removeFromSuperview];
	}
	NSInteger *numOfLabels = (NSInteger *)[[self.currentTask answer] length];
	for (int i = 0; i < (int)numOfLabels; i++) {
		CGRect frameRect = CGRectMake(0 + i * 50, 0, 40, 40);
		frameRect.size.width = 40;
		frameRect.size.height = 40;

		UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
		[label setBackgroundColor:[UIColor blueColor]];
		[label setText:@" "];
		[label setTag:100 + i];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label.heightAnchor constraintEqualToConstant:40].active = true;
		[label.widthAnchor constraintEqualToConstant:40].active = true;


		[self.answerCellStackView addSubview:label];
	}
}

- (void) answerStringIsChanged {
	NSInteger currentLength = [self.possibleAnswer length];
	NSInteger answerLength = [self.currentTask.answer length];

	for(int i = 0; i < answerLength; i++) {
		UILabel *label = [self.answerCellStackView viewWithTag:100 + i];
		if(label) {
			if ([label tag] - 100 < currentLength) {
				[label setText:[NSString stringWithFormat:@"%c", [self.possibleAnswer characterAtIndex:i]]];
			} else {
				[label setText:@" "];
			}
		}
	}

	if ([self.possibleAnswer length] >= [self.currentTask.answer length]) {
		[self.currentTask verifyAnswer:self.possibleAnswer];
		NSRange range = NSMakeRange(0, [self.possibleAnswer length]);
		[self.possibleAnswer deleteCharactersInRange:range];
		[self reloadSubview];
		[self.lettersCellCollectionView reloadData];
	}
}

//- (void) placingItems {
//	CGRect screenRect = [[UIScreen mainScreen] bounds];
//
//	[self.backgroundImage setFrame:screenRect];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)toMainView:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
@end
