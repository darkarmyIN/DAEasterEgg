//
//  DAEasterEggViewController.m
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/29/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

@import CoreMotion;

#import "DAEasterEggViewController.h"
#import "DALabel.h"

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

@property (nonatomic) NSDictionary *views;

@property (nonatomic) UILabel *dismissTextLabel;

@property (nonatomic) UIImageView *animatorImageView;

@property (nonatomic) DALabel *darkarmyLabel;

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
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animateWhiteRose];
	});
}

- (void)viewDidDisappear:(BOOL)animated {
	[self.motionManager stopAccelerometerUpdates];
}

#pragma mark - Animations

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
		
		self.animatorImageView.frame = CGRectMake(self.view.width - 64, 20, 44, 44);
		self.animatorImageView.alpha = 0.6;
		
	} completion:^(BOOL finished) {
		[self animateDarkArmyLabel];
	}];
}

- (void)animateDarkArmyLabel {
	
	__weak typeof (self) weakSelf = self;
	
	[self.darkarmyLabel setText:@"dark army" completion:^{
		
//		weakSelf.darkarmyLabel.transform = CGAffineTransformScale(weakSelf.darkarmyLabel.transform, 2.5, 2.5);
//		weakSelf.darkarmyLabel.font = [UIFont fontWithName:@"Phosphate-solid" size:18];
		
		[UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			weakSelf.darkarmyLabel.frame = CGRectMake(72, 20, self.view.width - 144, 44);
//			weakSelf.darkarmyLabel.font = [UIFont fontWithName:@"Phosphate-solid" size:18];
//			weakSelf.darkarmyLabel.transform = CGAffineTransformIdentity;
			
		} completion:^(BOOL finished) {
			[weakSelf addConstraints];
		}];
	}];
}

- (void)addConstraints {
	
	NSMutableArray *constraints = [NSMutableArray new];
	
	self.darkarmyLabel.transform = CGAffineTransformIdentity;
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[animatorImageView(44)]" options:0 metrics:nil views:self.views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[darkarmyLabel(44)]" options:0 metrics:nil views:self.views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[animatorImageView(44)]-20-|" options:0 metrics:nil views:self.views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=72)-[darkarmyLabel]-(>=72)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:self.views]];
	
	[NSLayoutConstraint activateConstraints:constraints];
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
		CGFloat width = MIN(self.view.width - 80, self.view.height - 80);
		_animatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, (self.view.height - width)/2, width, width)];
		self.animatorImageView.contentMode = UIViewContentModeScaleAspectFit;
		self.animatorImageView.clipsToBounds = YES;
		[self.view addSubview:self.animatorImageView];
	}
	
	if (!self.darkarmyLabel) {
		_darkarmyLabel = [[DALabel alloc] initWithFrame:CGRectMake(72, self.view.height/2 - 20, self.view.width - 144, 40)];
		[self.view addSubview:self.darkarmyLabel];
	}
	
	_views = @{
				@"dismissTextLabel": self.dismissTextLabel,
				@"animatorImageView": self.animatorImageView,
				@"darkarmyLabel": self.darkarmyLabel
			};
	
	NSMutableArray *constraints = [NSMutableArray new];
	
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dismissTextLabel(20)]-0-|" options:0 metrics:nil views:self.views]];
	[constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[dismissTextLabel]-20-|" options:0 metrics:nil views:self.views]];
	
	[NSLayoutConstraint activateConstraints:constraints];
}

@end
