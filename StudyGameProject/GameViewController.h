//
//  GameViewController.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 23.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIView *answerCellStackView;
@property (strong, nonatomic) IBOutlet UICollectionView *lettersCellCollectionView;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

- (void)gameIsEnded:(NSNotification *)notification;

- (void)taskWasSolved:(NSNotification *)notification;

@property (strong, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)toMainView:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *coinsBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *LetterView;

//@property NSArray *taskArray;

@end
