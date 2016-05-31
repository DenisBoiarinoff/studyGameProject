//
//  GameViewController1.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 30.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "GameViewController1.h"
#import "LetterCollectionViewCell.h"
#import "Task.h"
#import "TaskManager.h"
#import "UIColor+ColorFromHex.h"
#import "ViewCellStack.h"

@interface GameViewController1 ()

@property (nonatomic, strong) TaskManager *taskManger;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) Task *currentTask;

@property (nonatomic, strong) NSString *answerString;

@property (nonatomic, strong) NSMutableString *possibleAnswer;

@property (nonatomic, strong) NSNumber *coins;

@property (nonatomic, strong) ViewCellStack *cellStack;

@end

@implementation GameViewController1

const int numberOfLetter1 = 16;
const int taskCoast1 = 10;

static NSString *inputBtnImgUrl = @"/Users/rhinoda3/Documents/StudyGameProject/StudyGameProject/btn_input@2x.png";
static NSString *selectedLetterBtnImgUrl = @"/Users/rhinoda3/Documents/StudyGameProject/StudyGameProject/btn_letter@2x.png";
static NSString *stepBackImgUrl = @"/Users/rhinoda3/Documents/StudyGameProject/StudyGameProject/btn_return@2x.png";

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.cellStack = [[ViewCellStack alloc] init];

	self.coins = [NSNumber numberWithInt:0];
	[self.coinsBtn setTitle:[self.coins stringValue] forState:UIControlStateNormal];

	self.taskManger = [[TaskManager alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(gameIsEnded:)
												 name:@"TasksIsFinish"
											   object:self.taskManger];

	self.currentTask = nil;
	self.possibleAnswer = [[NSMutableString alloc] init];

	self.dataArray = [[NSMutableArray alloc] initWithCapacity:numberOfLetter1];
	for (int i = 0; i < numberOfLetter1; i++) {
		[self.dataArray addObject:@"0"];
	}

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	NSRange range = NSMakeRange(0, [self.possibleAnswer length]);
	[self.possibleAnswer deleteCharactersInRange:range];

	[self.cellStack clear];

	[self reloadTask];
	[self reloadAnswerView];
	[self reloadLettersView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
															int newCoins = [self.coins intValue] + taskCoast1;
															self.coins = [NSNumber numberWithInt:newCoins];
															[self.coinsBtn setTitle:[self.coins stringValue] forState:UIControlStateNormal];
															[self.cellStack clear];
														}]; // 2

	[alertController addAction:firstAction];

	[self presentViewController:alertController animated:YES completion:nil];

}

- (void)gameIsEnded:(NSNotification *)notification
{
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

- (IBAction)toMainView:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) reloadTask {

	if(!self.currentTask) {
		self.currentTask = [self.taskManger getTask];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(taskWasSolved:)
													 name:@"TaskIsSolved"
												   object:self.currentTask];
		[self reloadAnswerView];
	}

	NSArray *letterList = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0",
						   @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
						   @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
						   @"U", @"V", @"W", @"X", @"Y", @"Z", nil];

	[self.titleLabel setText:self.currentTask.question];
	[self.questionLabel setText:self.currentTask.question];
	NSString *answer = self.currentTask.answer;

	for (int i = 0; i < numberOfLetter1; i++) {
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
							  withObject:@" "];
	while ([answer length] + 2 != [array count]) {
		NSInteger rundInt = rand() % numberOfLetter1 - 1;
		NSNumber *num = [NSNumber numberWithInteger:rundInt];
		NSInteger location = [array indexOfObject:num];
		if (location == NSNotFound) {
			[array addObject:num];
			[self.dataArray replaceObjectAtIndex:rundInt
									  withObject:[NSString stringWithFormat:@"%c", [answer characterAtIndex:[array count] - 3]]];
		}
	}

	[self reloadLettersView];
}

- (void) reloadAnswerView {
	for(UIView *subview in [self.answerView subviews]) {
		if (subview.class != self.answerBgImg.class) {
			[subview removeFromSuperview];
		}
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

		UIImage *letterImg = [UIImage imageNamed:inputBtnImgUrl];
		CGSize imgSize = label.frame.size;

		UIGraphicsBeginImageContext( imgSize );
		[letterImg drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		label.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;


		[label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:30]];
		[label setTextColor:[UIColor colorwithHexString:@"091161" alpha:1]];

		[self.answerView addSubview:label];
	}
}

- (void) reloadLettersView {

	for(UIView *subview in [self.lettersView subviews]) {
		if (subview.class != self.answerBgImg.class) {
			[subview removeFromSuperview];
		}
	}

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	float letterViewHeight = parentWidth / 4;
	float cellSide = 0.5 * letterViewHeight - 10;

	for (int j = 0; j < 2; j++) {
		for (int i = 0; i < (int)(numberOfLetter1 / 2); i++) {

			CGRect frameRect = CGRectMake(5 + i * (cellSide + 10), 5 + j * (cellSide + 10), cellSide, cellSide);
			UIButton *letter = [[UIButton alloc] initWithFrame:frameRect];
			[letter setTitle:[self.dataArray objectAtIndex:i + (int)(numberOfLetter1 / 2) * j] forState:UIControlStateNormal];
//			NSLog(@"data array object: %@ and index: %d",[self.dataArray objectAtIndex:i + (int)(numberOfLetter1 / 2) * j], i + (int)(numberOfLetter1 / 2)*j);
			[letter setTag:200 + i + (int)(numberOfLetter1 / 2) * j];
			[letter setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
			[letter.heightAnchor constraintEqualToConstant:cellSide].active = true;
			[letter.widthAnchor constraintEqualToConstant:cellSide].active = true;

			UIImage *letterImg;
			if (i + (int)(numberOfLetter1 / 2) * j == 15) {
				letterImg = [UIImage imageNamed:stepBackImgUrl];
			} else {
				letterImg = [UIImage imageNamed:selectedLetterBtnImgUrl];
			}
			CGSize imgSize = letter.frame.size;

			UIGraphicsBeginImageContext( imgSize );
			[letterImg drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
			UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			letter.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

			[letter setFont:[UIFont fontWithName:@"Arial-BoldMT" size:30]];
			[letter setTitleColor: [UIColor colorwithHexString:@"091161" alpha:1] forState:UIControlStateNormal];

			[letter addTarget:self
					   action:@selector(letterBtnPressed:)
			 forControlEvents:UIControlEventTouchUpInside];

			[self.lettersView addSubview:letter];
		}
	}

}

-(IBAction)letterBtnPressed:(id)sender
{
	int letterIndex = (int)[sender tag];
	switch (letterIndex) {
		case 207:
			[self helpPopup];
			break;
		case 215:
			[self stepBack];
			break;
		default:
			[self letterSelected: letterIndex];
			break;
	}
}

- (void) stepBack {
	NSLog(@"step back");
	int lastLetterPosition = (int)[self.possibleAnswer length];
	if (lastLetterPosition > 0) {
		NSRange range = NSMakeRange(lastLetterPosition - 1, 1);
		[self.possibleAnswer deleteCharactersInRange:range];

		UILabel *lastFullView = [self.answerView viewWithTag:100 + lastLetterPosition - 1];

		if (lastFullView) {
			[lastFullView setText:@" "];

			UIImage *letterImg = [UIImage imageNamed:inputBtnImgUrl];
			CGSize imgSize = lastFullView.frame.size;

			UIGraphicsBeginImageContext( imgSize );
			[letterImg drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
			UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			lastFullView.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;
		}

		UIButton *popCell =	(UIButton *)[self.cellStack pop];
		[popCell setHidden:NO];
	}
}

- (void) helpPopup
{
	UIAlertController *alertController = [UIAlertController
										  alertControllerWithTitle:@"Problem!?"
										  message:@"Have you any problem!?\n We dont care!"
										  preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Back to task"
														  style:UIAlertActionStyleDefault
														handler:^(UIAlertAction * action) {}]; // 2

	[alertController addAction:firstAction];

	[self presentViewController:alertController animated:YES completion:nil];
}

- (void) letterSelected:(int) letterIndex
{
	NSLog(@"Selected letter with iondex %d", letterIndex);
	UIButton *btn = (UIButton *)[self.lettersView viewWithTag:letterIndex];

	[self.cellStack push:btn];
	NSMutableString *selectedLetter = [[NSMutableString alloc] initWithString:[btn.titleLabel text]];
	self.possibleAnswer = [[self.possibleAnswer  stringByAppendingString:selectedLetter] mutableCopy];
	[btn setHidden:YES];
	[self answerStringIsChanged];
}

- (void) answerStringIsChanged {
	NSInteger currentLength = [self.possibleAnswer length];
	NSInteger answerLength = [self.currentTask.answer length];

	for(int i = 0; i < answerLength; i++) {
		UILabel *label = [self.answerView viewWithTag:100 + i];
		if(label) {
			if ([label tag] - 100 < currentLength) {
				[label setText:[NSString stringWithFormat:@"%c", [self.possibleAnswer characterAtIndex:i]]];

				UIImage *letterImg = [UIImage imageNamed:selectedLetterBtnImgUrl];
				CGSize imgSize = label.frame.size;

				UIGraphicsBeginImageContext( imgSize );
				[letterImg drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
				UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();

				label.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

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
																	  [self.cellStack clear];
																  }]; // 2

			[alertController addAction:firstAction];

			[self presentViewController:alertController animated:YES completion:nil];
		}
		NSRange range = NSMakeRange(0, [self.possibleAnswer length]);
		[self.possibleAnswer deleteCharactersInRange:range];
		[self reloadAnswerView];
		[self reloadLettersView];
	}
}



@end
