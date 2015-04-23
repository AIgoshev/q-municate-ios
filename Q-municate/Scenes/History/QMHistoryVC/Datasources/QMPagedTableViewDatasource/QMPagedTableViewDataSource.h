//
//  QMPagedTableViewDatasource.h
//  Q-municate
//
//  Created by Andrey Ivanov on 01.04.15.
//  Copyright (c) 2015 Quickblox. All rights reserved.
//

#import "QMTableViewDataSource.h"

@interface QMPagedTableViewDataSource : QMTableViewDataSource

@property (assign, nonatomic, readonly) NSUInteger totalEntries;
@property (assign, nonatomic, readonly) NSUInteger loadedEntries;

- (void)resetPage;
- (QBGeneralResponsePage *)nextPage;
- (void)updateCurrentPageWithResponcePage:(QBGeneralResponsePage *)page;

@end
