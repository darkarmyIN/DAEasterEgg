//
//  DATerminalTextView.m
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/30/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import "DATerminalTextView.h"

#define CSK 0.06 // Character speed constant

@interface DATerminalTextView ()

@end

@implementation DATerminalTextView

- (instancetype)initWithFrame:(CGRect)frame {
//	NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
//	self = [super initWithFrame:frame textContainer:textContainer];
	self = [super initWithFrame:frame];
	if (self) {
		[self setupView];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
	self = [super initWithFrame:frame textContainer:textContainer];
	if (self) {
		[self setupView];
	}
	return self;
}

- (void)setupView {
	self.backgroundColor = [UIColor clearColor];
	
	self.autocorrectionType = UITextAutocorrectionTypeNo;
	self.spellCheckingType = UITextSpellCheckingTypeNo;
	self.keyboardAppearance = UIKeyboardAppearanceDark;
	self.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	self.font = [UIFont fontWithName:@"Menlo" size:14];
	self.textColor = [UIColor greenColor];
	self.tintColor = [UIColor greenColor];
	self.textContainerInset = UIEdgeInsetsZero;
	
	self.linePrefix = @"\n→ ~  ";
	self.text = [self.linePrefix substringFromIndex:1];
}

- (void)typeText:(NSString *)text atIndex:(NSUInteger)index {
	if (index == text.length) {
		return;
	}
	[super setText:[self.text stringByAppendingString:[NSString stringWithFormat:@"%c", [text characterAtIndex:index]]]];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CSK * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self typeText:text atIndex:index + 1];
	});
}

- (void)addText:(NSString *)text completion:(void (^)(void))completion {
	[self addText:text autoReturn:NO completion:completion];
}

- (void)addText:(NSString *)text autoReturn:(BOOL)autoReturn completion:(void (^)(void))completion {
	if (![self.text hasSuffix:self.linePrefix]) {
		self.text = [self.text stringByAppendingString:self.linePrefix];
	}
	[self typeText:text atIndex:0];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((text.length + 4) * CSK * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		if (autoReturn)
			[self.delegate textView:self shouldChangeTextInRange:NSMakeRange(self.text.length - 1, 0) replacementText:@"\n"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			if (completion != nil)
				completion();
		});
	});
}

- (void)setMultiLineText:(NSArray *)texts atIndex:(NSUInteger)index {
	[self setMultiLineText:texts atIndex:index autoReturn:NO];
}

- (void)setMultiLineText:(NSArray *)texts atIndex:(NSUInteger)index autoReturn:(BOOL)autoReturn {
	if (index == texts.count) {
		return;
	}
	BOOL shouldType = ([[texts objectAtIndex:index] characterAtIndex:0] == 'Y');
	NSString *text = [[texts objectAtIndex:index] substringFromIndex:2];
	__weak typeof (self) wself = self;
	if (shouldType) {
		[self addText:text autoReturn:autoReturn completion:^{
			[wself setMultiLineText:texts atIndex:index + 1 autoReturn:autoReturn];
		}];
	} else {
		self.text = [self.text stringByAppendingString:text];
		if (autoReturn)
			[self.delegate textView:self shouldChangeTextInRange:NSMakeRange(self.text.length - 1, 0) replacementText:@"\n"];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self setMultiLineText:texts atIndex:index + 1 autoReturn:autoReturn];
		});
	}
}

- (void)setMultiLineText:(NSString *)text completion:(void (^)(void))completion {
	[self setMultiLineText:text autoReturn:NO completion:completion];
}

- (void)setMultiLineText:(NSString *)text autoReturn:(BOOL)autoReturn completion:(void (^)(void))completion {
	NSArray *texts = [text componentsSeparatedByString:@"\n"];
	[self setMultiLineText:texts atIndex:0 autoReturn:autoReturn];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((text.length + texts.count * 6) * CSK * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		completion();
	});
}

@end

#pragma mark - Terminal text view handler

@implementation DATerminalTextViewHandler

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		NSString *lastCommand = [[textView.text componentsSeparatedByString:@"\n"] lastObject];
		if (lastCommand.length < self.textView.linePrefix.length) return NO;
		NSString *ptext = [lastCommand substringFromIndex:self.textView.linePrefix.length - 1];
		if ([ptext isEqualToString:@"clear"]) {
			[textView setText:[self.textView.linePrefix substringFromIndex:1]];
			return NO;
		} else if ([ptext hasPrefix:@"cd"]) {
			if ([ptext isEqualToString:@"cd"]) {
				self.textView.linePrefix = @"\n→ ~  ";
				textView.text = [textView.text stringByAppendingString:self.textView.linePrefix];
			} else {
				NSString *path = [ptext substringFromIndex:2];
				NSString *lastPathComponent = [path lastPathComponent];
				self.textView.linePrefix = [[self.textView.linePrefix substringToIndex:3] stringByAppendingString:[NSString stringWithFormat:@"%@  ", lastPathComponent]];
				textView.text = [textView.text stringByAppendingString:self.textView.linePrefix];
			}
			return NO;
		} else if ([ptext hasPrefix:@"./fuxsocy.py"]) {
			if (ptext.length > 2) {
				[self.delegate terminalTextViewHandler:self finishAnimations:YES];
			}
		}
		textView.text = [textView.text stringByAppendingString:self.textView.linePrefix];
		return NO;
	}
	return YES;
}

@end
