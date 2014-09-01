//
//  QMFriendsListDataSource.m
//  Q-municate
//
//  Created by Andrey Ivanov on 4/3/14.
//  Copyright (c) 2014 Quickblox. All rights reserved.
//

#import "QMFriendsListDataSource.h"
#import "QMUsersService.h"
#import "QMFriendListCell.h"
#import "QMContactRequestCell.h"
#import "QMApi.h"
#import "QMUsersService.h"
#import "SVProgressHud.h"
#import "QMChatReceiver.h"

#import "QMSearchDataSource.h"
#import "QMDefaultDataSource.h"
#import "QMContactRequestDataSource.h"



@interface QMFriendsListDataSource()


@property (strong, nonatomic) NSArray *searchResult;
@property (strong, nonatomic) NSArray *friendList;
@property (strong, nonatomic) NSArray *contactRequests;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UISearchDisplayController *searchDisplayController;
@property (strong, nonatomic) NSObject<Cancelable> *searchOperation;

@property (strong, nonatomic) QMTableDataSource *tableDataSource;

@property (strong, nonatomic) id tUser;

@end

@implementation QMFriendsListDataSource

@synthesize friendList = _friendList;

- (void)dealloc {
    ILog(@"%@ - %@",  NSStringFromSelector(_cmd), self);
    [[QMChatReceiver instance] unsubscribeForTarget:self];
}

- (instancetype)initWithTableView:(UITableView *)tableView searchDisplayController:(UISearchDisplayController *)searchDisplayController {
    
    self = [super init];
    if (self) {
        
        self.tableView = tableView;
//        [self setUpTableDataSource];
        self.tableView.dataSource = self;
        self.searchResult = [NSArray array];
        
        self.searchDisplayController = searchDisplayController;
        __weak __typeof(self)weakSelf = self;
        
        void (^reloadDatasource)(void) = ^(void) {
            
            if (weakSelf.searchOperation) {
                return;
            }
            
            if (weakSelf.searchDisplayController.isActive) {
                
                CGPoint point = weakSelf.searchDisplayController.searchResultsTableView.contentOffset;
                
                weakSelf.friendList = [QMApi instance].friends;
                [weakSelf.searchDisplayController.searchResultsTableView reloadData];
                NSUInteger idx = [weakSelf.friendList indexOfObject:weakSelf.tUser];
                NSUInteger idx2 = [weakSelf.searchResult indexOfObject:weakSelf.tUser];
               
                if (idx != NSNotFound && idx2 != NSNotFound) {
                    
                    point .y += 59;
                    weakSelf.searchDisplayController.searchResultsTableView.contentOffset = point;
                    
                    weakSelf.tUser = nil;
                    [SVProgressHUD dismiss];
                }
                
            }
            else {
                [weakSelf reloadDatasource];
            }
        };
        
        [[QMChatReceiver instance] contactRequestUsersListChangedWithTarget:self block:^{
            weakSelf.contactRequests = [QMApi instance].contactRequestUsers;
            
            [weakSelf.tableView reloadData];
        }];
        
        [[QMChatReceiver instance] usersHistoryUpdatedWithTarget:self block:reloadDatasource];
        [[QMChatReceiver instance] chatContactListUpdatedWithTarget:self block:reloadDatasource];
        
        UINib *nib = [UINib nibWithNibName:@"QMFriendListCell" bundle:nil];
        [searchDisplayController.searchResultsTableView registerNib:nib
                                             forCellReuseIdentifier:kQMFriendsListCellIdentifier];
        [searchDisplayController.searchResultsTableView registerNib:nil forCellReuseIdentifier:kQMContactRequestCellIdentifier];
//        searchDisplayController.searchResultsDataSource = self;
    }
    
    return self;
}

- (void)setFriendList:(NSArray *)friendList {
    _friendList = [QMUsersUtils sortUsersByFullname:friendList];
}

- (NSArray *)friendList {
    
    if (self.searchDisplayController.isActive && self.searchDisplayController.searchBar.text.length > 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fullName CONTAINS[cd] %@", self.searchDisplayController.searchBar.text];
        NSArray *filtered = [_friendList filteredArrayUsingPredicate:predicate];
        
        return filtered;
    }
    return _friendList;
}

- (void)reloadDatasource {
    
    self.friendList = [QMApi instance].friends;
    [self.tableView reloadData];
}

- (void)globalSearch:(NSString *)searchText {
    
    if (searchText.length == 0) {
        self.searchResult = @[];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    
    __weak __typeof(self)weakSelf = self;
    QBUUserPagedResultBlock userPagedBlock = ^(QBUUserPagedResult *pagedResult) {
        
        NSArray *users = [QMUsersUtils sortUsersByFullname:pagedResult.users];
        //Remove current user from search result
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.ID != %d", [QMApi instance].currentUser.ID];
        weakSelf.searchResult = [users filteredArrayUsingPredicate:predicate];
        [weakSelf.searchDisplayController.searchResultsTableView reloadData];
        weakSelf.searchOperation = nil;
        [SVProgressHUD dismiss];
    };
    
    [self.searchDisplayController.searchResultsTableView reloadData];
    
    __block NSString *tsearch = [searchText copy];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([weakSelf.searchDisplayController.searchBar.text isEqualToString:tsearch]) {
            
            if (weakSelf.searchOperation) {
                [weakSelf.searchOperation cancel];
                weakSelf.searchOperation = nil;
            }
            
            PagedRequest *request = [[PagedRequest alloc] init];
            request.page = 1;
            request.perPage = 100;
            
            
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            weakSelf.searchOperation = [[QMApi instance].usersService retrieveUsersWithFullName:searchText pagedRequest:request completion:userPagedBlock];
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSArray *users = [self usersAtSections:section];
    if (self.searchDisplayController.isActive) {
        
        if (section == 0) {
            return users.count > 0 ? NSLocalizedString(@"QM_STR_FRIENDS", nil) : nil;
        }
        return users.count > 0 ? NSLocalizedString(@"QM_STR_ALL_USERS", nil) : nil;
        
    } else if ([self.contactRequests count] > 0) {
        if (section == 0) {
            return users.count > 0 ? NSLocalizedString(@"QM_STR_REQUESTS", nil) : nil;
        }
        return users.count > 0 ? NSLocalizedString(@"QM_STR_FRIENDS", nil) : nil;
    }
    return users.count > 0 ? NSLocalizedString(@"QM_STR_FRIENDS", nil) : nil;;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchDisplayController.isActive || [[QMApi instance].contactRequestUsers count] > 0) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *users = [self usersAtSections:section];
    if (self.searchDisplayController.isActive) {
        return users.count;
    }
    return users.count > 0 ? users.count : 1;
}

- (NSArray *)usersAtSections:(NSInteger)section
{
    if (section == 0 ) {
        return ([self.contactRequests count] > 0 && !self.searchDisplayController.isActive) ? self.contactRequests : self.friendList;
    }
    if (self.searchDisplayController.isActive) {
        return self.searchResult;
    }
    
    if ([self.contactRequests count] > 0) {
        return self.friendList;
    }
    return nil;
}

- (QBUUser *)userAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *users = [self usersAtSections:indexPath.section];
    QBUUser *user = users[indexPath.row];
    
    return user;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *users = [self usersAtSections:indexPath.section];
    
    if (!self.searchDisplayController.isActive) {
        if (users.count == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQMDontHaveAnyFriendsCellIdentifier];
            return cell;
        }
    }
    QMTableViewCell *cell = nil;
    if ([self.contactRequests count] > 0 && indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kQMContactRequestCellIdentifier];
        ((QMContactRequestCell *)cell).delegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:kQMFriendsListCellIdentifier];
        ((QMFriendListCell *)cell).delegate = self;
    }
    QBUUser *user = users[indexPath.row];
    
    QBContactListItem *item = [[QMApi instance] contactItemWithUserID:user.ID];
    cell.contactlistItem = item;
    cell.userData = user;
    
    if(self.searchDisplayController.isActive) {
        ((QMFriendListCell *)cell).searchText = self.searchDisplayController.searchBar.text;
    }
    
    
    return cell;
}

//- (void)setUpTableDataSource
//{
//    if (self.searchDisplayController.isActive) {
//        if (![self.tableDataSource isKindOfClass:QMSearchDataSource.class]) {
//            self.tableDataSource = [[QMSearchDataSource alloc] initWithFriendsListDataSource:self];
//            self.searchDisplayController.searchResultsDataSource = self.tableDataSource;
//            self.tableView.dataSource = self.tableDataSource;
//        }
//        self.tableDataSource.friends = self.friendList;
//        self.tableDataSource.otherUsers = self.searchResult;
//        ((QMSearchDataSource *)self.tableDataSource).searchString = self.searchDisplayController.searchBar.text;
//        return;
//    }
//    if ([self.contactRequests count] > 0) {
//        if (![self.tableDataSource isKindOfClass:QMContactRequestDataSource.class]) {
//            self.tableDataSource = [[QMContactRequestDataSource alloc] initWithFriendsListDataSource:self];
//            self.tableView.dataSource = self.tableDataSource;
//        }
//        self.tableDataSource.friends = self.friendList;
//        self.tableDataSource.otherUsers = self.contactRequests;
//        return;
//    }
//    // default statte:
//    if (![self.tableDataSource isKindOfClass:QMDefaultDataSource.class]) {
//        self.tableDataSource = [QMDefaultDataSource new];
//        self.tableView.dataSource = self.tableDataSource;
//    }
//    self.tableDataSource.friends = self.friendList;
//}


#pragma mark - QMUsersListCellDelegate

- (void)usersListCell:(QMFriendListCell *)cell pressAddBtn:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
    NSArray *datasource = [self usersAtSections:indexPath.section];
    QBUUser *user = datasource[indexPath.row];
    
    __weak __typeof(self)weakSelf = self;
    [[QMApi instance] addUserToContactListRequest:user completion:^(BOOL success) {
        if (success) {
            weakSelf.tUser = user;
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        }
    }];
}

- (void)usersListCell:(QMTableViewCell *)cell requestWasAccepted:(BOOL)accepted
{
    QBUUser *user = cell.userData;
    QMApi *api = [QMApi instance];
    [api.usersService.confirmRequestUsersIDs removeObject:@(user.ID)];
    self.contactRequests = api.contactRequestUsers;
    [self reloadDatasource];
//    __weak __typeof(self)weakSelf = self;
//    
//    if (accepted) {
//        [[QMApi instance] confirmAddContactRequest:user.ID completion:^(BOOL success) {
//            //to do:
//        }];
//    } else {
//        [[QMApi instance] rejectAddContactRequest:user.ID completion:^(BOOL success) {
//            // to do:
//        }];
//    }
}


#pragma mark - UISearchDisplayController

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self globalSearch:searchString];
    return NO;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    //
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [self.tableView reloadData];
}

@end
