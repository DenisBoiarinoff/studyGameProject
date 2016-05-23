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

@property (nonatomic, retain) GameViewController *gameViewController;

@end
