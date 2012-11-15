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
    BOOL success;
}

// initiate Database
-(id) initDB;

// Insert new records
-(void) insertCategory:(NSString *) categoryName;
-(void) insertBudget:(NSDate *) date andBudget:(NSNumber *) budget;
-(void) insertTransactions:(NSDate *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) amount;

// Update existing records
-(void) updateCategory:(NSString *) oldCategoryName andNewName:(NSString *) newCategoryName;
-(void) updateBudget:(NSDate *) date andBudget:(NSNumber *) newBudget;
-(void) updateTransactions:(NSDate *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) newAmount;

// Fetch records
-(NSNumber *) getCID: (NSString *) categoryName;
-(NSString *) getCategoryName: (NSNumber *) cID;
-(NSString *) getDate;
-(NSNumber *) getBudget: (NSDate *) date;
-(NSNumber *) getTotal: (NSDate *) date;
-(NSMutableDictionary *) getTransactions: (NSDate *) date;
-(NSNumber *) getAmount: (NSDate *) date andCID: (NSNumber *) cID;
-(NSNumber *) getAmount: (NSDate *) date andCategoryName: (NSString *) cName;
-(NSMutableArray *) getCategories;

// Delete records
-(void) deleteCategory:(NSString *) categoryName;
-(void) deleteBudget:(NSDate *) date;
-(void) deleteTransactions:(NSDate *) date andCID: (NSNumber *) cID;

//database status
-(BOOL) succeed;
-(NSString *) errMsg;

// Close database
-(void) closeDB;

@end
