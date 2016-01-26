//
//  ColorPallete.m
//  SwiftStitch
//
//  Created by pc on 11/12/15.
//  Copyright © 2015 ellipsis.com. All rights reserved.
//

#import "ColorPallete.h"

@implementation ColorPallete

@synthesize lightGreen;
@synthesize darkGreen;
@synthesize darkBlue;
@synthesize lightBlue;
@synthesize darkRed;
@synthesize lightRed;
@synthesize lightYellow;
@synthesize darkYellow;
@synthesize backGround;
@synthesize sideBackGround;
@synthesize textSideBar;
@synthesize sideBackGroundLight;

+ (id)sharedManager {
    static ColorPallete *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}


- (id)init {
    if (self = [super init]) {
        lightGreen = [UIColor colorWithRed:249.0f/255.0f green:254.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
        darkGreen = [UIColor colorWithRed:105.0f/255.0f green:169.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        darkRed = [UIColor colorWithRed:151.0f/255.0f green:17.0f/255.0f blue:0.0f alpha:1.0f];
        lightRed = [UIColor colorWithRed:251.0f/255.0f green:231.0f/255.0f blue:239.0f/255.0f alpha:1.0f];
        lightBlue = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:1.0f alpha:1.0f];
        darkBlue = [UIColor colorWithRed:26.0f/255.0f green:115.0f/255.0f blue:166.0f/255.0f alpha:1.0f];
        lightYellow = [UIColor colorWithRed:255.0f/255.0f green:254.0f/255.0f blue:238.0f alpha:1.0f];
        darkYellow = [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
        backGround = [UIColor colorWithRed:22.0f/255.0f green:41.0f/255.0f blue:52.0f/255.0f alpha:1.0f];
        sideBackGround = [UIColor colorWithRed:46.0f/255.0f green:55.0f/255.0f blue:68.0f/255.0f alpha: 0.90f];
        textSideBar = [UIColor colorWithRed:185.0f/255.0f green:203.0f/255.0f blue:217.0f/255.0f alpha:1];
        sideBackGroundLight = [UIColor colorWithRed:46.0f/255.0f green:55.0f/255.0f blue:68.0f/255.0f alpha:0.9f];
//        46,55,68,0.9
//        46,55,68,0.9
    
    }
    return self;
}
@end


