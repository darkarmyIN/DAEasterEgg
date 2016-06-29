//
//  DAEasterEggViewController.h
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/29/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PresentationType) {
	PresentationTypeXY,
	PresentationTypeYZ,
	PresentationTypeZX,
};

@interface DAEasterEggViewController : UIViewController

@property (nonatomic) PresentationType ptype;

@end
