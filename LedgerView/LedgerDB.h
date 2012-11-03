//
//  LedgerDB.h
//  Ledgerdary
//
//  Created by YenHsiang Wang on 10/18/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface LedgerDB : NSObject {
    sqlite3 *ledgerDB;
}

// initiate Database
-(id) initDB;

// Insert new records
-(void) insertCategory:(NSString *) categoryName;
-(void) insertBudget:(NSString *) date andBudget:(NSNumber *) budget;
-(void) insertTransactions:(NSString *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) amount;

// Update existing records
-(void) updateCategory:(NSString *) oldCategoryName andNewName:(NSString *) newCategoryName;
-(void) updateBudget:(NSString *) date andBudget:(NSNumber *) newBudget;
-(void) updateTransactions:(NSString *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) newAmount;

// Fetch records
-(NSNumber *) getCID: (NSString *) categoryName;
-(NSString *) getCategoryName: (NSNumber *) cID;
-(NSString *) getDate;
-(NSNumber *) getBudget: (NSString *) date;
-(NSNumber *) getTotal: (NSString *) date;
-(NSNumber *) getAmount: (NSString *) date andCID: (NSNumber *) cID;
-(NSNumber *) getAmount: (NSString *) date andCategoryName: (NSString *) cName;
-(NSMutableArray *) getCategories;

// Delete records
-(void) deleteCategory:(NSString *) categoryName;
-(void) deleteBudget:(NSString *) date;
-(void) deleteTransactions:(NSString *) date andCID: (NSNumber *) cID;

// Close database
-(void) closeDB;

@end
