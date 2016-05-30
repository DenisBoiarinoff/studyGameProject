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
#import "ViewCellStack.h"

@interface GameViewController ()

@property TaskManager *taskManger;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property Task *currentTask;

@property NSString *answerString;

@property NSMutableString *possibleAnswer;

@property NSNumber *coins;

@property ViewCellStack *cellStack;

@end

@implementation GameViewController

static NSString *cellIdentifier = @"LatterCollectionViewCell";

const int numberOfLetter = 16;

const int taskCoast = 10;

static NSString *inputBtnImgUrl = @"/Users/rhinoda3/Documents/StudyGameProject/StudyGameProject/btn_input@2x.png";

static NSString *selectedLetterBtnImgUrl = @"/Users/rhinoda3/Documents/StudyGameProject/StudyGameProject/btn_letter@2x.png";

- (void)viewDidLoad {
	[super viewDidLoad];

	self.cellStack = [[ViewCellStack alloc] init];

	self.lettersCellCollectionView.backgroundColor =  [UIColor colorwithHexString:@"FFFFFF" alpha:0];

	self.coins = [NSNumber numberWithInt:0];
	[self.coinsBtn setTitle:[self.coins stringValue] forState:UIControlStateNormal];
	
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

	self.dataArray = [[NSMutableArray alloc] initWithCapacity:numberOfLetter];
	for (int i = 0; i < numberOfLetter; i++) {
		[self.dataArray addObject:@"1"];
	}

	[self.lettersCellCollectionView setScrollEnabled:false];
	
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	NSRange range = NSMakeRange(0, [self.possibleAnswer length]);
	[self.possibleAnswer deleteCharactersInRange:range];

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
	NSLog(@"cell text: %@ and indexPath.row: %ld", [cell.letter text], indexPath.row);
	if (cell) {
		int helpIndex = (int)[self.dataArray count] / 2 - 1;
		int backIndex = (int)[self.dataArray count] - 1;
		if ((indexPath.row != helpIndex ) && (indexPath.row != backIndex)) {
			[self.cellStack push:cell];
			NSMutableString *selectedLetter = [[NSMutableString alloc] initWithString:[cell.letter text]];
			self.possibleAnswer = [[self.possibleAnswer  stringByAppendingString:selectedLetter] mutableCopy];
			[cell setHidden:YES];
			[self answerStringIsChanged];
		}
		if (indexPath.row == helpIndex) {
			UIAlertController *alertController = [UIAlertController
												  alertControllerWithTitle:@"Problem!?"
												  message:@"Have you any problem!?\n We dont care!"
												  preferredStyle:UIAlertControllerStyleAlert];

			UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Back to task"
																  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
																  }]; // 2

			[alertController addAction:firstAction];

			[self presentViewController:alertController animated:YES completion:nil];

		}
		if (indexPath.row == backIndex) {
			[self stepBack];
		}
		//		[self isItAnswer];
		//		[(UIButton *)[self.answerCellStackView viewWithTag:10] setTitle:[cell.letter text] forState:UIControlStateNormal];
		//		NSLog(@"cell text: %@", [cell.letter text]);

		//		[(UILabel *)[self.answerCellStackView viewWithTag:10] setText:[cell.letter text]];

	}
	//	NSLog(@"Did select item: %@", [self.lettersCellCollectionView cellForItemAtIndexPath:indexPath] );
	//	NSLog(@"Did select item: %ld", indexPath.row);
	
}

- (void) stepBack {
	int lastLetterPosition = (int)[self.possibleAnswer length];
	if (lastLetterPosition > 0) {
		NSLog(@"%d", lastLetterPosition);
		NSRange range = NSMakeRange(lastLetterPosition - 1, 1);
		[self.possibleAnswer deleteCharactersInRange:range];

		UILabel *lastFullView = [self.answerCellStackView viewWithTag:100 + lastLetterPosition - 1];

		if (lastFullView) {
			[lastFullView setText:@" "];
			lastFullView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:inputBtnImgUrl]];
		}

		LetterCollectionViewCell *popCell =	(LetterCollectionViewCell *)[self.cellStack pop];
		[popCell setHidden:NO];
	}
}

- (void) taskWasSolved:(NSNotification *)notification
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

	int newCoins = [self.coins intValue] + taskCoast;
	self.coins = [NSNumber numberWithInt:newCoins];
	[self.coinsBtn setTitle:[self.coins stringValue] forState:UIControlStateNormal];

}



- (void)gameIsEnded:(NSNotification *)notification {

	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Sorry!!!"
										  message:@"game is over!"
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

	[self.titleLabel setText:self.currentTask.question];
	[self.questionLabel setText:self.currentTask.question];
	NSString *answer = self.currentTask.answer;

	for (int i = 0; i < numberOfLetter; i++) {
		NSInteger rundInt = rand() % ([letterList count] - 1);
		NSString *str = [letterList objectAtIndex:rundInt];
		[self.dataArray replaceObjectAtIndex:i withObject:str];
	}
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:[NSNumber numberWithInt:7]];
	[self.dataArray replaceObjectAtIndex:7
							  withObject:@"?"];
	[array addObject:[NSNumber numberWithInt:15]];
	[self.dataArray replaceObjectAtIndex:15
							  withObject:@"~"];
	while ([answer length] + 2 != [array count]) {
		NSInteger rundInt = rand() % numberOfLetter - 1;
		NSNumber *num = [NSNumber numberWithInteger:rundInt];
		NSInteger location = [array indexOfObject:num];
		if (location == NSNotFound) {
			[array addObject:num];
			[self.dataArray replaceObjectAtIndex:rundInt
									  withObject:[NSString stringWithFormat:@"%c", [answer characterAtIndex:[array count] - 3]]];
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
	int cellWidth = 40;
	int indent = 10;
	int cellGroopWidth = ((int)numOfLabels * cellWidth)	+ ((int)numOfLabels - 1) * indent;
	int praentWidth = [[UIScreen mainScreen] bounds].size.width;
	float cellGroopLeading = (praentWidth - cellGroopWidth ) / 2;

	for (int i = 0; i < (int)numOfLabels; i++) {
		CGRect frameRect = CGRectMake(cellGroopLeading + i * 50, 12, 40, 40);
		frameRect.size.width = 40;
		frameRect.size.height = 40;

		UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
		[label setText:@" "];
		[label setTag:100 + i];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label.heightAnchor constraintEqualToConstant:40].active = true;
		[label.widthAnchor constraintEqualToConstant:40].active = true;

		label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:inputBtnImgUrl]];


		[label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:30]];
		[label setTextColor:[UIColor colorwithHexString:@"091161" alpha:1]];

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
				label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:selectedLetterBtnImgUrl]];
			} else {
//				[label setText:@" "];
//				label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:inputBtnImgUrl]];
			}
		}
	}

	if ([self.possibleAnswer length] >= [self.currentTask.answer length]) {
		bool isSolvd = [self.currentTask verifyAnswer:self.possibleAnswer];
		if (!isSolvd) {
			UIAlertController *alertController = [UIAlertController
												  alertControllerWithTitle:@"Oh no!!!"
												  message:@"Wrong answer!"
												  preferredStyle:UIAlertControllerStyleAlert];

			UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Back to task"
																  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
																  }]; // 2

			[alertController addAction:firstAction];

			[self presentViewController:alertController animated:YES completion:nil];
		}
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
