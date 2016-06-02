//
//  GameViewController1.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 30.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

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

@property (nonatomic, strong) UILabel *animationLabel;

@end

@implementation GameViewController1

const int numberOfLetter1 = 16;
const int taskCoast1 = 10;

int tytleFontSize;
int cellFontSize;
float cellSize;

static NSString *inputBtnImg = @"btn_input";
static NSString *selectedLetterBtnImg = @"btn_letter";
static NSString *stepBackImg = @"btn_return";
static NSString *btnHelpImg = @"btn_hint";

- (void)viewDidLoad
{
	[super viewDidLoad];

	CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef soundfileURLRef;
	soundfileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"tap", CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(soundfileURLRef,  & _soundBackId);
	soundfileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"letter_tap", CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(soundfileURLRef,  & _soundLetterId);
	soundfileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"fail", CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(soundfileURLRef,  & _soundFailId);
	soundfileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"success", CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(soundfileURLRef,  & _soundWinId);

	CGRect frameRect = CGRectMake(0, 0, cellSize, cellSize);
	self.animationLabel = [[UILabel alloc] initWithFrame:frameRect];

//	UIImage *letterImg = [UIImage imageNamed:inputBtnImg];
//	UIImage *letterImgMirored = [UIImage imageWithCGImage:letterImg.CGImage
//													scale:letterImg.scale
//											  orientation:UIImageOrientationDownMirrored];
//	CGSize imgSize = self.animationLabel.frame.size;
//
//	UIGraphicsBeginImageContext( imgSize );
//	[letterImgMirored drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
//	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//	UIGraphicsEndImageContext();
//
//	self.animationLabel.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

	[self.animationLabel setText:@"X"];

//	[self.animationLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:cellFontSize]];
//	[self.animationLabel setTextColor:[UIColor colorwithHexString:@"091161" alpha:1]];

//	[self.animationLabel setHidden:YES];
	[self.view addSubview:self.animationLabel];

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

	int parentWidth = [[UIScreen mainScreen] bounds].size.width;
	float letterViewHeight = parentWidth / 4;
	cellSize = 0.5 * letterViewHeight - 10;

	cellFontSize  = (int)(cellSize * 0.7);
	tytleFontSize = [[UIScreen mainScreen] bounds].size.height * 0.1 * 0.7 * 0.5;

//	[self.questionLabel setAdjustsFontSizeToFitWidth:YES];
	[self.questionLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:tytleFontSize]];
	[self.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:tytleFontSize]];

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
	AudioServicesDisposeSystemSoundID(_soundBackId);
	AudioServicesDisposeSystemSoundID(_soundFailId);
	AudioServicesDisposeSystemSoundID(_soundLetterId);
	AudioServicesDisposeSystemSoundID(_soundWinId);
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
	AudioServicesPlaySystemSound(_soundWinId);
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
	AudioServicesPlaySystemSound(_soundBackId);
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
							  withObject:@" "];
	[array addObject:[NSNumber numberWithInt:15]];
	[self.dataArray replaceObjectAtIndex:15
							  withObject:@" "];
	while ([answer length] + 2 != [array count]) {
		NSInteger rundInt = rand() % (numberOfLetter1 - 1);
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

	int indent = 10;
	int cellGroopWidth = ((int)numOfLabels * cellSize)	+ ((int)numOfLabels - 1) * indent;
	int praentWidth = [[UIScreen mainScreen] bounds].size.width;
	float cellGroopLeading = (praentWidth - cellGroopWidth ) / 2;

	for (int i = 0; i < (int)numOfLabels; i++) {
		CGRect frameRect = CGRectMake(cellGroopLeading + i * (cellSize + indent),
									  ([[UIScreen mainScreen] bounds].size.height * 0.1 - cellSize) / 2,
									  cellSize,
									  cellSize);
		frameRect.size.width = cellSize;
		frameRect.size.height = cellSize;

		UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
		[label setText:@" "];
		[label setTag:100 + i];
		[label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:cellFontSize]];
		[label setTextColor:[UIColor colorwithHexString:@"091161" alpha:1]];
		[label setTextAlignment:NSTextAlignmentCenter];

		UIImage *letterImg = [UIImage imageNamed:inputBtnImg];
		UIImage *letterImgMirored = [UIImage imageWithCGImage:letterImg.CGImage
													 scale:letterImg.scale
											   orientation:UIImageOrientationDownMirrored];
		CGSize imgSize = label.frame.size;

		UIGraphicsBeginImageContext( imgSize );
		[letterImgMirored drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
		UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();

		label.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

		[self.answerView addSubview:label];
	}
}

- (void) reloadLettersView {

	for(UIView *subview in [self.lettersView subviews]) {
		if (subview.class != self.answerBgImg.class) {
			[subview removeFromSuperview];
		}
	}

	for (int j = 0; j < 2; j++) {
		for (int i = 0; i < (int)(numberOfLetter1 / 2); i++) {

			CGRect frameRect = CGRectMake(5 + i * (cellSize + 10), 5 + j * (cellSize + 10), cellSize, cellSize);
			UIButton *letter = [[UIButton alloc] initWithFrame:frameRect];
			[letter setTitle:[self.dataArray objectAtIndex:i + (int)(numberOfLetter1 / 2) * j] forState:UIControlStateNormal];
			[letter setTag:200 + i + (int)(numberOfLetter1 / 2) * j];
			[letter setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];

			UIImage *letterImg;
			if (i + (int)(numberOfLetter1 / 2) * j == 15) {
				letterImg = [UIImage imageNamed:stepBackImg];
			} else if (i + (int)(numberOfLetter1 / 2) * j == 7) {
				letterImg = [UIImage imageNamed:btnHelpImg];
			} else {
				letterImg = [UIImage imageNamed:selectedLetterBtnImg];
			}
			UIImage *letterImgMirored = [UIImage imageWithCGImage:letterImg.CGImage
													 scale:letterImg.scale
											   orientation:UIImageOrientationDownMirrored];
			CGSize imgSize = letter.frame.size;

			UIGraphicsBeginImageContext( imgSize );
			[letterImgMirored drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
			UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			letter.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

			[letter setFont:[UIFont fontWithName:@"Arial-BoldMT" size:cellFontSize]];
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
	AudioServicesPlaySystemSound(_soundLetterId);
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
//	NSLog(@"step back");
	int lastLetterPosition = (int)[self.possibleAnswer length];
	if (lastLetterPosition > 0) {
		NSRange range = NSMakeRange(lastLetterPosition - 1, 1);
		[self.possibleAnswer deleteCharactersInRange:range];

		UILabel *lastFullView = [self.answerView viewWithTag:100 + lastLetterPosition - 1];

		if (lastFullView) {
			CGRect startFrame = [self.answerView convertRect:lastFullView.frame toView:self.view];
			UIButton *letterBtn = [self.cellStack lastObject];
			CGRect endFrame = [self.lettersView convertRect:letterBtn.frame toView:self.view];
			[self.animationLabel setFrame:startFrame];

			UIImage *animationLetterImg = [UIImage imageNamed:selectedLetterBtnImg];
			UIImage *animationLetterImgMirored = [UIImage imageWithCGImage:animationLetterImg.CGImage
															scale:animationLetterImg.scale
													  orientation:UIImageOrientationDownMirrored];

			//	CGSize imgSize = self.animationLabel.frame.size;
			CGSize animationImgSize = startFrame.size;

			UIGraphicsBeginImageContext( animationImgSize );
			[animationLetterImgMirored drawInRect:CGRectMake(0,0,animationImgSize.width, animationImgSize.height)];
			UIImage* newAnimationImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			self.animationLabel.layer.backgroundColor = [UIColor colorWithPatternImage:newAnimationImage].CGColor;

			[self.animationLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:cellFontSize]];
			[self.animationLabel setTextColor:[UIColor colorwithHexString:@"091161" alpha:1]];

			//	[self.animationLabel setText:@"X"];
			[self.animationLabel setText:lastFullView.text];
			[self.animationLabel setTextAlignment:NSTextAlignmentCenter];
			[self.animationLabel setHidden:NO];

			[lastFullView setText:@" "];

			UIImage *letterImg = [UIImage imageNamed:inputBtnImg];
			UIImage *letterImgMirored = [UIImage imageWithCGImage:letterImg.CGImage
															scale:letterImg.scale
													  orientation:UIImageOrientationDownMirrored];
			CGSize imgSize = lastFullView.frame.size;

			UIGraphicsBeginImageContext( imgSize );
			[letterImgMirored drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
			UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();

			lastFullView.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

			[UIView animateWithDuration:1.f
								  delay:.1f
								options:UIViewAnimationCurveEaseInOut
							 animations:^{
								 [self.animationLabel setCenter:CGPointMake(endFrame.origin.x + endFrame.size.width/2,
																			endFrame.origin.y + endFrame.size.height/2)];
							 }
							 completion:^(BOOL finished){
								 UIButton *popCell = (UIButton *)[self.cellStack pop];
								 [popCell setHidden:NO];
								 [self.animationLabel setHidden:YES];
							 }
			 ];


		}


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
//	NSLog(@"Selected letter with iondex %d", letterIndex);
	UIButton *btn = (UIButton *)[self.lettersView viewWithTag:letterIndex];

	[self.cellStack push:btn];

	NSMutableString *selectedLetter = [[NSMutableString alloc] initWithString:[btn.titleLabel text]];
	self.possibleAnswer = [[self.possibleAnswer  stringByAppendingString:selectedLetter] mutableCopy];

	CGRect startFrame = [self.lettersView convertRect:btn.frame toView:self.view];
/*for future replace*/
	NSInteger currentLength = [self.possibleAnswer length];
	UILabel *lastClearLabel = [self.answerView viewWithTag:99 + currentLength];
/*--*/
	CGRect endFrame = [self.answerView convertRect:lastClearLabel.frame toView:self.view];

//	[self.animationLabel setText:selectedLetter];
	[self.animationLabel setFrame:startFrame];

//	[self.animationLabel setBackgroundColor:[UIColor redColor]];
//	self.animationLabel.layer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:selectedLetterBtnImg]].CGColor;

	UIImage *letterImg = [UIImage imageNamed:selectedLetterBtnImg];
	UIImage *letterImgMirored = [UIImage imageWithCGImage:letterImg.CGImage
													scale:letterImg.scale
											  orientation:UIImageOrientationDownMirrored];

//	CGSize imgSize = self.animationLabel.frame.size;
	CGSize imgSize = startFrame.size;

	UIGraphicsBeginImageContext( imgSize );
	[letterImgMirored drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	self.animationLabel.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

	[self.animationLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:cellFontSize]];
	[self.animationLabel setTextColor:[UIColor colorwithHexString:@"091161" alpha:1]];

//	[self.animationLabel setText:@"X"];
	[self.animationLabel setText:selectedLetter];
	[self.animationLabel setTextAlignment:NSTextAlignmentCenter];
	[self.animationLabel setHidden:NO];

	[btn setHidden:YES];

	[UIView animateWithDuration:1.f
						  delay:.1f
						options:UIViewAnimationCurveEaseInOut
					 animations:^{
						 [self.animationLabel setCenter:CGPointMake(endFrame.origin.x + endFrame.size.width/2,
																	endFrame.origin.y + endFrame.size.height/2)];
					 }
					 completion:^(BOOL finished){
						 [self.animationLabel setHidden:YES];
						 [self answerStringIsChanged];
					 }
	 ];


}

- (void) answerStringIsChanged {
	NSInteger currentLength = [self.possibleAnswer length];
	NSInteger answerLength = [self.currentTask.answer length];

	for(int i = 0; i < answerLength; i++) {
		UILabel *label = [self.answerView viewWithTag:100 + i];
		if(label) {
			if ([label tag] - 100 < currentLength) {

				[label setText:[NSString stringWithFormat:@"%c", [self.possibleAnswer characterAtIndex:i]]];

				UIImage *letterImg = [UIImage imageNamed:selectedLetterBtnImg];
				UIImage *letterImgMirored = [UIImage imageWithCGImage:letterImg.CGImage
																scale:letterImg.scale
														  orientation:UIImageOrientationDownMirrored];
				CGSize imgSize = label.frame.size;

				UIGraphicsBeginImageContext( imgSize );
				[letterImgMirored drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
				UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
				UIGraphicsEndImageContext();

				label.layer.backgroundColor = [UIColor colorWithPatternImage:newImage].CGColor;

			}
		}
	}

	if ([self.possibleAnswer length] >= [self.currentTask.answer length]) {
		bool isSolvd = [self.currentTask verifyAnswer:self.possibleAnswer];
		if (!isSolvd) {
			AudioServicesPlaySystemSound(_soundFailId);
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
