//
//  MainViewController.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 23.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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