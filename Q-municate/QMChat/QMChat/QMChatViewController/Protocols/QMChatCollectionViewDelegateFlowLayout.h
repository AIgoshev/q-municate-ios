//
//  QMChatCollectionViewDelegateFlowLayout.h
//  QMChat
//
//  Created by Andrey Ivanov on 20.04.15.
//  Copyright (c) 2015 QuickBlox Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class QMChatCollectionView;
@class QMChatCollectionViewFlowLayout;
@class QMChatCollectionViewCell;
@class QMLoadEarlierHeaderView;
@class QMChatCellLayoutAttributes;

/**
 *  The `QMChatCollectionViewDelegateFlowLayout` protocol defines methods that allow you to
 *  manage additional layout information for the collection view and respond to additional actions on its items.
 *  The methods of this protocol are all optional.
 */
@protocol QMChatCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@optional

- (QMChatCellLayoutAttributes *)collectionView:(QMChatCollectionView *)collectionView cellLayoutAttributes:(NSIndexPath *)indexPath;

/**
 *  Notifies the delegate that the collection view's header did receive a tap event.
 *
 *  @param collectionView The collection view object that is notifying the delegate of the tap event.
 *  @param headerView     The header view in the collection view.
 *  @param sender         The button that was tapped.
 */
- (void)collectionView:(QMChatCollectionView *)collectionView
                header:(QMLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender;

@end