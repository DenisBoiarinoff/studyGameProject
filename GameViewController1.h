//
//  GameViewController1.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 30.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController1 : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet UIView *lettersView;

@property (strong, nonatomic) IBOutlet UIButton *coinsBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (strong, nonatomic) IBOutlet UIImageView *answerBgImg;

- (void)gameIsEnded:(NSNotification *)notification;
- (void)taskWasSolved:(NSNotification *)notification;

- (IBAction)toMainView:(id)sender;

@property UInt32 soundLetterId;
@property UInt32 soundBackId;
@property UInt32 soundFailId;
@property UInt32 soundWinId;

@property bool sound;

@end
