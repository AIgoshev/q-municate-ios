//
//  QMChatContainerView.h
//  Q-municate
//
//  Created by Andrey Ivanov on 14.05.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface QMChatContainerView : UIView

@property (strong, nonatomic) IBInspectable UIColor *bgColor;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;

@end
