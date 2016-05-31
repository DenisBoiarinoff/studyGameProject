//
//  UIColor+ColorFromHex.h
//  StudyGameProject
//
//  Created by Rhinoda3 on 27.05.16.
//  Copyright © 2016 Rhinoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFromHex)

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
