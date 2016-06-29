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
@property (nonatomic) UIImageView *animatorImageView;
//@property (nonatomic) NSLayoutConstraint *animatorImageViewTopConstraint;

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

- (void)viewDidAppear:(BOOL)animated {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateWhiteRose];
	});
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.motionManager stopAccelerometerUpdates];
}

- (void)animateWhiteRose {
	NSMutableArray *images = [NSMutableArray new];
	self.animatorImageView.image = [UIImage imageNamed:@"whiterose.bundle/WhiteRose.jpg"];
	for (NSInteger i = 1; i < 18; ++i) {
		[images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"whiterose.bundle/assets/%.2li", i]]];
	}
	self.animatorImageView.animationImages = images;
	self.animatorImageView.animationDuration = 1.6;
	self.animatorImageView.animationRepeatCount = 1;
	[self.animatorImageView startAnimating];
	[UIView animateWithDuration:0.8 delay:1.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.animatorImageView.layer.transform = CATransform3DTranslate(CATransform3DMakeScale(0.16, 0.16, 0.16), self.view.width/.40, -self.view.height/.5, 0);
		self.animatorImageView.alpha = 0.4;
	} completion:^(BOOL finished) {
		
	}];
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
	
	if (!self.animatorImageView) {
		_animatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiterose.bundle/assets/00"]];
		self.animatorImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.animatorImageView.clipsToBounds = YES;
		[self.view addSubview:self.animatorImageView];
		self.animatorImageView.translatesAutoresizingMaskIntoConstraints = NO;
	}
	
	NSDictionary *views = @{
							@"dismissTextLabel": self.dismissTextLabel,
							@"animatorImageView": self.animatorImageView
							};
	
	NSMutableArray *constraints = [NSMutableArray new];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[animatorImageView]-(>=60)-[dismissTextLabel(20)]-0-|" options:0 metrics:nil views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[dismissTextLabel]-20-|" options:0 metrics:nil views:views]];
	
	[constraints addObject:[NSLayoutConstraint constraintWithItem:self.animatorImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.animatorImageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==40)-[animatorImageView(>=240)]-(==40)-|" options:0 metrics:nil views:views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==120)-[animatorImageView]" options:0 metrics:nil views:views]];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

@end
