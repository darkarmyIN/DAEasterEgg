//
//  DALabel.m
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/30/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DALabel.h"

@implementation DALabel {
	NSInteger fontSize;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		fontSize = 54;
		self.font = [UIFont fontWithName:@"Phosphate-solid" size:fontSize];
		self.textAlignment = NSTextAlignmentCenter;
		self.textColor = [UIColor whiteColor];
		self.characterSpeed = 0.15;
	}
	return self;
}

- (void)setText:(NSString *)text characterWise:(NSInteger)index {
	if (index == text.length) {
		return;
	}
	[super setText:[text substringToIndex:index + 1]];
	fontSize -= 4;
	self.font = [UIFont fontWithName:@"Phosphate-solid" size:fontSize];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.characterSpeed * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self setText:text characterWise:index + 1];
	});
}

- (void)setText:(NSString *)text {
	[self setText:text characterWise:0];
}

- (void)setText:(NSString *)text completion:(void (^)(void))completion {
	[self setText:[text uppercaseString]];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.characterSpeed * (text.length) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		completion();
	});
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
