//
//  DALabel.h
//  DAEasterEgg
//
//  Created by Avikant Saini on 6/30/16.
//  Copyright © 2016 Dark Army. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DALabel : UILabel

@property (nonatomic) CGFloat characterSpeed;

- (void)setText:(NSString *)text completion:(void (^)(void))completion;

@end
