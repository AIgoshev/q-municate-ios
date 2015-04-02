//
//  QMFriendListCell.m
//  Q-municate
//
//  Created by Andrey Ivanov on 25/02/2014.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMFriendListCell.h"
#import "QMImageView.h"

@interface QMFriendListCell()

@property (weak, nonatomic) IBOutlet UIImageView *onlineCircle;
@property (weak, nonatomic) IBOutlet UIButton *addToFriendsButton;

@property (assign, nonatomic) BOOL isFriend;
@property (assign, nonatomic) BOOL online;

@end

@implementation QMFriendListCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//    _isFriend = YES;
//    self.addToFriendsButton.hidden = self.isFriend;
//    self.onlineCircle.hidden = YES;
//    self.descriptionLabel.text = NSLocalizedString(@"QM_STR_OFFLINE", nil);
//}
//
//- (void)setUserData:(id)userData {
//
//    _userData = userData;
//    
//    QBUUser *user = userData;
//    self.titleLabel.text = (user.fullName.length == 0) ? @"" : user.fullName;
//    NSURL *avatarUrl = nil;//[QMUsersUtils userAvatarURL:user];
//    [self setUserImageWithUrl:avatarUrl];
//}
//
//- (void)setOnline:(BOOL)online {
//    
//    if (_online != online) {
//        _online = online;
//    }
//    self.onlineCircle.hidden = !online;
//}
//
//- (void)setContactlistItem:(QBContactListItem *)contactlistItem {
//
//    _contactlistItem = contactlistItem;
//    
//    self.online = contactlistItem.online;
//    self.isFriend = contactlistItem ?  YES : NO;
//    
//    NSString *status = nil;
//    
//    if (!contactlistItem) {
//        status = @"";
//    } else if (contactlistItem.subscriptionState == QBPresenseSubscriptionStateBoth || contactlistItem.subscriptionState == QBPresenseSubscriptionStateFrom) {
//        status = NSLocalizedString(contactlistItem.online ? @"QM_STR_ONLINE": @"QM_STR_OFFLINE", nil);
//    } else {
//        status = NSLocalizedString(@"QM_STR_PENDING", nil);
//    }
//    self.descriptionLabel.text = status;
//}
//
//- (void)setIsFriend:(BOOL)isFriend {
//    
//    _isFriend = isFriend;
//    
//    self.addToFriendsButton.hidden = isFriend;
//    if (!_isFriend) {
//        self.descriptionLabel.text = @"";
//    }
//}
//
//- (void)setSearchText:(NSString *)searchText {
//    
//    _searchText = searchText;
//    if (_searchText.length > 0) {
//        
//        QBUUser *user = self.userData;
//        NSString *fullName = user.fullName;
//        
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:fullName];
//        [text addAttribute: NSForegroundColorAttributeName
//                     value:[UIColor redColor]
//                     range:[fullName.lowercaseString rangeOfString:searchText.lowercaseString]];
//        
//        self.titleLabel.attributedText = text;
//    }
//}

#pragma mark - Actions

- (IBAction)pressAddBtn:(UIButton *)sender {
    
//    if ([self.delegate respondsToSelector:@selector(usersListCell:pressAddBtn:)]) {
//        
//        [self.delegate usersListCell:self
//                         pressAddBtn:sender];
//    }
}

@end