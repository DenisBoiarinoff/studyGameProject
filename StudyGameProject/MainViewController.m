//
//  MainViewController.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 23.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>

#import "MainViewController.h"
#import "UIColor+ColorFromHex.h"
#import "GameViewController1.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.titleLabel setAdjustsFontSizeToFitWidth:YES];

	[self.navigationController.navigationBar setHidden:YES];

	CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef soundfileURLRef;
	soundfileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"tap", CFSTR("wav"), NULL);
	AudioServicesCreateSystemSoundID(soundfileURLRef,  & _soundId);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
	AudioServicesDisposeSystemSoundID(_soundId);
}

- (IBAction)toGameView:(id)sender {

	AudioServicesPlaySystemSound(_soundId);

	switch ([sender tag]) {
		case 10:
			[self gameViewStart];
			break;

		default:
			break;
	}



}

- (IBAction)soundSwich:(id)sender {
}

- (void) gameViewStart
{
	if(!self.gameViewController1){
		GameViewController1 *secondView = [[GameViewController1 alloc] init];
		self.gameViewController1 = secondView;
	}

	[self.navigationController pushViewController:self.gameViewController1 animated:YES];
}
@end
