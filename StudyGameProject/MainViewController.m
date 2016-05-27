//
//  MainViewController.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 23.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"
#import "UIColor+ColorFromHex.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];



//	CGRect screenRect = [[UIScreen mainScreen] bounds];
//
//	[self.fontImageView setFrame:screenRect];
//
//	CGRect newFrame = self.hawToPlayBtn.frame;
//
//	newFrame.size.width = screenRect.size.width - 80;
//	newFrame.size.height = newFrame.size.width / 5;
//	newFrame.origin.y = screenRect.size.height / 2 -  newFrame.size.height / 2;
//	newFrame.origin.x = screenRect.size.width / 2 - newFrame.size.width / 2;
//	[self.hawToPlayBtn setFrame:newFrame];
//
//	newFrame = self.playBtn.frame;
//	newFrame.size.width = screenRect.size.width - 80;
//	newFrame.size.height = newFrame.size.width / 5;
//	newFrame.origin.y = screenRect.size.height / 2 -  newFrame.size.height * 1.5 - 20;
//	newFrame.origin.x = screenRect.size.width / 2 - newFrame.size.width / 2;
//	[self.playBtn setFrame:newFrame];
//
//	newFrame = self.StoreBtn.frame;
//	newFrame.size.width = screenRect.size.width - 80;
//	newFrame.size.height = newFrame.size.width / 5;
//	newFrame.origin.y = screenRect.size.height / 2 + newFrame.size.height * 0.5 + 20;
//	newFrame.origin.x = screenRect.size.width / 2 - newFrame.size.width / 2;
//	[self.StoreBtn setFrame:newFrame];
//
//	newFrame = self.titleLabel.frame;
//	newFrame.origin.y = 25;
//	newFrame.origin.x = screenRect.size.width / 2 - newFrame.size.width / 2;
//	[self.titleLabel setFrame:newFrame];
//
	[self.navigationController.navigationBar setHidden:YES];
//	[self.navigationController.navigationBar setBackgroundColor:[UIColor colorwithHexString:@"FFFFFF" alpha:.0]];

//	[self setTitle:@"Riddles"];
//
//	CAGradientLayer *gradient = [CAGradientLayer layer];
//	gradient.frame = self.navigationController.navigationBar.bounds;
//	gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorwithHexString:@"ED540A" alpha:.9] CGColor],
//					   (id)[[UIColor colorwithHexString:@"FFFF1F" alpha:.9] CGColor], nil];
//
//	[self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];

	// Do any additional setup after loading the view from its nib.
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

- (IBAction)toGameView:(id)sender {

	if(!self.gameViewController){
		GameViewController *secondView = [[GameViewController alloc] init];
		self.gameViewController = secondView;
	}

	[self.navigationController pushViewController:self.gameViewController animated:YES];

}
@end
