//
//  LetterCollectionViewCell.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 24.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "LetterCollectionViewCell.h"

@implementation LetterCollectionViewCell

@synthesize letter = _letter;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {

		// Initialization code
		NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"LetterCollectionViewCell" owner:self options:nil];

		if ([arrayOfViews count] < 1) {
			return nil;
		}

		if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
			return nil;
		}

		self = [arrayOfViews objectAtIndex:0];

	}

	return self;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
