//
//  DAEasterEggViewController.m
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/29/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DAEasterEggViewController.h"

@interface DAEasterEggViewController ()

@end

@implementation DAEasterEggViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

@end
