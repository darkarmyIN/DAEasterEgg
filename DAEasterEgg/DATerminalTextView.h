//
//  DATerminalTextView.h
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/30/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DATerminalTextView : UITextView

@property (nonatomic) NSString *linePrefix;

- (void)addText:(NSString *)text completion:(void (^)(void))completion;
- (void)addText:(NSString *)text autoReturn:(BOOL)autoReturn completion:(void (^)(void))completion;
- (void)setMultiLineText:(NSString *)text completion:(void (^)(void))completion;
- (void)setMultiLineText:(NSString *)text autoReturn:(BOOL)autoReturn completion:(void (^)(void))completion;

@end

@protocol DATerminalTextViewHandlerDelegate;

@interface DATerminalTextViewHandler : NSObject <UITextViewDelegate>

@property (nonatomic, weak) id<DATerminalTextViewHandlerDelegate>delegate;
@property (nonatomic, weak) DATerminalTextView *textView;

@end

@protocol DATerminalTextViewHandlerDelegate <NSObject>
- (void)terminalTextViewHandler:(DATerminalTextViewHandler *)handler finishAnimations:(BOOL)finished;
@end