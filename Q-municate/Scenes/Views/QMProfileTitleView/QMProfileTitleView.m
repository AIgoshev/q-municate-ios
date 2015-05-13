//
//  QMOnlineTitle.m
//  Q-municate
//
//  Created by Andrey Ivanov on 14.08.14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMProfileTitleView.h"
#import "QMImageView.h"

const CGFloat kQMMaxProfileTileViewWidth = 150;

@interface QMProfileTitleView()

@property (weak, nonatomic) IBOutlet QMImageView *qmImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;
@property (weak, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation QMProfileTitleView

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    
    if (self) {
        self.userInteractionEnabled = YES;
        self.qmImageVIew.imageViewType = QMImageViewTypeCircle;
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
        self.tapGestureRecognizer = tapGesture;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    
    if (![_title isEqualToString:title]) {
        
        _title = title;
        
        self.label.text = title;
        
        NSMutableParagraphStyle* ovalStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        ovalStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* attributes =
        @{NSFontAttributeName: self.label.font,
          NSForegroundColorAttributeName:[UIColor whiteColor],
          NSParagraphStyleAttributeName:ovalStyle};
        
        CGSize size = CGSizeMake(kQMMaxProfileTileViewWidth, self.label.frame.size.height);
        
        CGRect textRect = [title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes
                                              context:nil];
        
        self.labelWidth.constant = MIN(textRect.size.width, kQMMaxProfileTileViewWidth);
        
        [self setNeedsDisplay];
    }
}

- (void)setUserImageWithUrl:(NSString *)url {
 
    
    [self.qmImageVIew setImageWithURL:url
                          placeholder:nil options:SDWebImageLowPriority progress:nil completedBlock:nil];
}

#pragma mark - Tap gesture

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    
    [self.delegate profileTitleViewDidTap:self];
}

@end