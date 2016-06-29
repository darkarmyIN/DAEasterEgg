//
//  DAEasterEggViewController.m
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/29/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

@import CoreMotion;

#import "DAEasterEggViewController.h"

#pragma mark - View Utils

@interface UIView (ViewUtils)

- (CGFloat)width;
- (CGFloat)height;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

@end

@implementation UIView (ViewUtils)

- (CGFloat)width { return self.bounds.size.width; }
- (CGFloat)height { return self.bounds.size.height; }

+ (CGFloat)screenWidth { return [UIScreen mainScreen].bounds.size.width; }
+ (CGFloat)screenHeight { return [UIScreen mainScreen].bounds.size.height; }

@end

#pragma mark -

@interface DAEasterEggViewController ()

@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic) UILabel *dismissTextLabel;

@end

@implementation DAEasterEggViewController

- (instancetype)init {
	self = [super init];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self setupSubViews];
	
	self.motionManager = [[CMMotionManager alloc] init];
	self.motionManager.deviceMotionUpdateInterval = 1.0/3.0;
}

- (void)viewWillAppear:(BOOL)animated {
	[self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
		if (fabs(accelerometerData.acceleration.x) > 3 || fabs(accelerometerData.acceleration.y) > 3 || fabs(accelerometerData.acceleration.z) > 3) {
			[self dismissViewControllerAnimated:YES completion:nil];
		}
	}];
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.motionManager stopAccelerometerUpdates];
}

#pragma mark - View setup

- (void)setupSubViews {
	self.view.backgroundColor = [UIColor blackColor];
	if (!self.dismissTextLabel) {
		_dismissTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.height - 20, self.view.width - 40, 20)];
		self.dismissTextLabel.textColor = [UIColor whiteColor];
		self.dismissTextLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
		self.dismissTextLabel.textAlignment = NSTextAlignmentCenter;
		self.dismissTextLabel.text = @"Pan in one direction quickly to go back.";
		[self.view addSubview:self.dismissTextLabel];
		self.dismissTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	NSDictionary *views = @{@"dismissTextLabel": self.dismissTextLabel};
	
	NSMutableArray *constraints = [NSMutableArray new];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dismissTextLabel(20)]-0-|" options:0 metrics:nil views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[dismissTextLabel]-20-|" options:0 metrics:nil views:views]];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

@end
