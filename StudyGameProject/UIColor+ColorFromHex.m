//
//  UIColor+ColorFromHex.m
//  StudyGameProject
//
//  Created by Rhinoda3 on 27.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import "UIColor+ColorFromHex.h"

@implementation UIColor (ColorFromHex)

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
	//-----------------------------------------
	// Convert hex string to an integer
	//-----------------------------------------
	unsigned int hexint = 0;

	// Create scanner
	NSScanner *scanner = [NSScanner scannerWithString:hexStr];

	// Tell scanner to skip the # character
	[scanner setCharactersToBeSkipped:[NSCharacterSet
									   characterSetWithCharactersInString:@"#"]];
	[scanner scanHexInt:&hexint];

	//-----------------------------------------
	// Create color object, specifying alpha
	//-----------------------------------------
	UIColor *color =
	[UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
					green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
					 blue:((CGFloat) (hexint & 0xFF))/255
					alpha:alpha];

	return color;
}

@end
