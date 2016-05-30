//
//  MainViewController.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 23.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameViewController;

@interface MainViewController : UIViewController

- (IBAction)toGameView:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *fontImageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIButton *hawToPlayBtn;
@property (strong, nonatomic) IBOutlet UIButton *storeBtn;

@property (nonatomic, retain) GameViewController *gameViewController;

@end