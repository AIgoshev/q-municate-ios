//
//  QBChatDialog.h
//  Quickblox
//
//  Created by Igor Alefirenko on 23/04/2014.
//  Copyright (c) 2014 QuickBlox. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface QBChatDialog : NSObject <NSCoding, NSCopying> {
@private
    NSString *ID;
    NSString *name;
    NSString *roomJID;
    NSString *lastMessageText;
    NSDate *lastMessageDate;
    NSUInteger lastMessageUserID;
    NSUInteger unreadMessagesCount;
    NSArray *occupantIDs;
    enum QBChatDialogType type;
    NSUInteger unreadMessageCount;
}

/** Object ID */
@property (nonatomic, retain) NSString *ID;

/** Room JID. If private chat, room JID will be nil */
@property (nonatomic, retain) NSString *roomJID;

/** Chat type: Private/Group/PublicGroup */
@property (nonatomic) enum QBChatDialogType type;

/** Group chat name. If chat type is private, name will be nil */
@property (nonatomic, retain) NSString *name;

/** Last message text in private or group chat */
@property (nonatomic, retain) NSString *lastMessageText;

/** Date of last message in private or group chat */
@property (nonatomic, retain) NSDate *lastMessageDate;

/** User ID of last opponent in private or group chat */
@property (nonatomic, assign) NSUInteger lastMessageUserID;

/** Number of unread messages in this dialog */
@property (nonatomic, assign) NSUInteger unreadMessagesCount;

/** Array of user ids in chat. For private chat count = 2 */
@property (nonatomic, retain) NSArray *occupantIDs;

/** Unread messages count. If you create dialog, count will be 0 */
@property (nonatomic, assign) NSUInteger unreadMessageCount;

@end
