//
//  ColorPallete.h
//  SwiftStitch
//
//  Created by pc on 11/12/15.
//  Copyright © 2015 ellipsis.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorPallete : NSObject

@property (nonatomic, retain) UIColor *lightGreen;
@property (nonatomic, retain) UIColor *darkGreen;
@property (nonatomic, retain) UIColor *lightRed;
@property (nonatomic, retain) UIColor *darkRed;
@property (nonatomic, retain) UIColor *lightBlue;
@property (nonatomic, retain) UIColor *darkBlue;
@property (nonatomic, retain) UIColor *lightYellow;
@property (nonatomic, retain) UIColor *darkYellow;
@property (nonatomic, retain) UIColor *backGround;
@property (nonatomic, retain) UIColor *sideBackGround;
@property (nonatomic, retain) UIColor *textSideBar;
@property (nonatomic, retain) UIColor *sideBackGroundLight;

+ (id)sharedManager;
@end
