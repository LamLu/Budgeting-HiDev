//
//  LedgerDB.m
//  Ledgerdary
//
//  Created by YenHsiang Wang on 10/18/12.
//  Copyright (c) 2012 YenHsiang Wang. All rights reserved.
//

#import "LedgerDB.h"
@interface LedgerDB (private)

-(void) createCategoryTable;
-(void) createBudgetTable;
-(void) createTransactionTable;
-(void) showErrMsg: (NSString *) msg;

//debugging methods
-(void) forTesting;
-(void) dropTable:(NSString *) tableName;
-(void) display;
-(void) insertDefaultRecords;


@end


@implementation LedgerDB
/*
 *  Initialize the Database. Create a new one if it does not exsit,
 *  otherwise open the existing one.
 */
-(id) initDB {
    NSLog(@"Initializing Database");
    if (self = [super init]) {
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [path objectAtIndex:0];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"contacts.sqlite"];
        
        const char *dbPathString = [dbPath UTF8String];
        
        //create db here
        if (sqlite3_open(dbPathString, &ledgerDB) == SQLITE_OK) {
            NSLog(@"Ledger DB created");
        } else {
            NSLog(@"Error: failed to CREATE/OPEN database due to %s.", sqlite3_errmsg(ledgerDB));
        }
        
        char *error;
        NSString *enable_FK = [NSString stringWithFormat:@"PRAGMA foreign_keys = ON"];
        if (sqlite3_exec(ledgerDB, [enable_FK UTF8String], NULL, NULL, &error) != SQLITE_OK) {
            NSLog(@"Error: failed to ENABLE Forign Key due to %s", sqlite3_errmsg(ledgerDB));
        }
        
        //create tables here
        [self createCategoryTable];
        [self createBudgetTable];
        [self createTransactionTable];

        [self forTesting];
    }
    
    return self;
}

-(void) forTesting {
    //drop tables
    //[self dropTable:@"TRANSACTIONS"];
    //[self dropTable:@"BUDGET"];
    //[self dropTable:@"CATEGORY"];
    //[self insertDefaultRecords];
    //[self display];
}

//Create Tables
-(void) createCategoryTable {
    char *error;
    const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS CATEGORY ("
        "   cID     INTEGER PRIMARY KEY AUTOINCREMENT, "
        "   NAME    TEXT UNIQUE NOT NULL"
        ")";
    if (sqlite3_exec(ledgerDB, sql_stmt, NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: @"CREATE CATEGORY TABLE"];
        //NSLog(@"Error: failed to CREATE CATEGORY Table due to %s", sqlite3_errmsg(ledgerDB));
    }
}

-(void) createBudgetTable {
    char *error;
    const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS BUDGET ("
        "   DATE    TEXT NOT NULL PRIMARY KEY, "
        "   BUDGET  REAL"
        ");";
    if (sqlite3_exec(ledgerDB, sql_stmt, NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: @"CREATE BUDGET TABLE"];
        //NSLog(@"Error: failed to CREATE CATEGIRY Table due to %s", sqlite3_errmsg(ledgerDB));
    }
}

-(void) createTransactionTable {
    char *error;
    const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS TRANSACTIONS ("
        "   TIME    TEXT NOT NULL,"
        "   cID     INTEGER NOT NULL,"
        "   AMOUNT  REAL NOT NULL,"
        "   FOREIGN KEY (TIME) REFERENCES BUDGET(DATE),"
        "   FOREIGN KEY (cID) REFERENCES CATEGORY(cID)"
        ");";
    if (sqlite3_exec(ledgerDB, sql_stmt, NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: @"CREATE TRANSACTIONS TABLE"];
        //NSLog(@"Error: failed to CREATE CATEGIRY Table due to %s", sqlite3_errmsg(ledgerDB));
    }
    
    const char *index_stmt =
    "CREATE UNIQUE INDEX IF NOT EXISTS TRAN_ID_INDEX ON TRANSACTIONS (TIME, cID);";
    if (sqlite3_exec(ledgerDB, index_stmt, NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: @"CREATE INDEX on TRANSACTIONS"];
        //NSLog(@"Error: failed to CREATE index on TRANSACTIONS due to %s", sqlite3_errmsg(ledgerDB));
    }
}

//Insert Records
-(void) insertCategory:(NSString *) categoryName {
    char *error;
    NSString *insert_stmt =
    [NSString stringWithFormat:@"INSERT INTO CATEGORY(NAME) VALUES ('%@')", categoryName];
    
    if (sqlite3_exec(ledgerDB, [insert_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"INSERT %@ INTO CATEGORY TABLE", categoryName]];
        //NSLog(@"Error: failed to INSERT CATEGIRY Table due to %s", sqlite3_errmsg(ledgerDB));
    }
}

-(void) insertBudget:(NSString *) date andBudget:(NSNumber *) budget {
    char *error;
    NSString *insert_stmt =
    [NSString stringWithFormat:@"INSERT INTO BUDGET(DATE, BUDGET) VALUES ('%@', %f)", date, [budget doubleValue]];
    
    if (sqlite3_exec(ledgerDB, [insert_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"INSERT %@ INTO BUDGET TABLE", budget]];
        //NSLog(@"Error: failed to INSERT budget due to %s", sqlite3_errmsg(ledgerDB));
    }
}

-(void) insertTransactions:(NSString *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) amount {
    char *error;
    NSString *insert_stmt =
    [NSString stringWithFormat:@"INSERT INTO TRANSACTIONS VALUES ('%@', %d, %f)", date, [cID integerValue], [amount doubleValue]];
    
    if (sqlite3_exec(ledgerDB, [insert_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"INSERT %@ INTO TRANSACTIONS TABLE", amount]];
    }
}

//Update Records
-(void) updateCategory:(NSString *) oldCategoryName andNewName:(NSString *) newCategoryName{
    char *error;
    NSString *update_stmt =
    [NSString stringWithFormat:@"UPDATE CATEGORY SET NAME = '%@' WHERE NAME = '%@' ", newCategoryName, oldCategoryName];
    
    if (sqlite3_exec(ledgerDB, [update_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"UPDATE %@ in CATEGORY TABLE", newCategoryName]];
    }
}

-(void) updateBudget:(NSString *) date andBudget:(NSNumber *) newBudget {
    char *error;
    NSString *update_stmt =
    [NSString stringWithFormat:@"UPDATE BUDGET SET Budget = '%@' WHERE DATE = '%@' ", newBudget, date];
    
    if (sqlite3_exec(ledgerDB, [update_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"UPDATE %@ in BUDGET TABLE", newBudget]];
    }
}

-(void) updateTransactions:(NSString *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) newAmount {
    char *error;
    NSString *update_stmt =
    [NSString stringWithFormat:@"UPDATE TRANSACTIONS SET Amount = '%f' WHERE TIME = '%@' AND cID = '%@'", [newAmount doubleValue], date, cID];
    
    if (sqlite3_exec(ledgerDB, [update_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"UPDATE %@ in TRANSACTIONS TABLE", newAmount]];
    }
}

//Delete Records
-(void) deleteCategory:(NSString *) categoryName {
    char *error;
    NSString *delete_stmt =
    [NSString stringWithFormat:@"DELETE FROM CATEGORY WHERE NAME = '%@'", categoryName];
    
    if (sqlite3_exec(ledgerDB, [delete_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"DELETE %@ FROM CATEGORY TABLE", categoryName]];
    }
}

-(void) deleteBudget:(NSString *) date {
    [self updateBudget:date andBudget: [NSNumber numberWithFloat: 0]];
}

-(void) deleteTransactions:(NSString *) date andCID: (NSNumber *) cID {
    char *error;
    NSString *delete_stmt =
    [NSString stringWithFormat:@"DELETE FROM TRANSACTIONS WHERE TIME = '%@' AND cID = '%@'", date, cID];
    
    if (sqlite3_exec(ledgerDB, [delete_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"DELETE Transaction %@ on %@ FROM CATEGORY TABLE", cID, date]];
    }
}

// Fetch records
-(NSNumber *) getCID: (NSString *) categoryName {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT cID FROM CATEGORY WHERE NAME = '%@'", categoryName];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithInt: sqlite3_column_int(select, 0)];
    }
    else {
        [self showErrMsg: [NSString stringWithFormat:@"SELECT cID for '%@'", categoryName]];
        return nil;
    }
}

-(NSString *) getCategoryName: (NSNumber *) cID {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT NAME FROM CATEGORY WHERE cID = '%@'", cID];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)];
    }
    else {
        [self showErrMsg: [NSString stringWithFormat:@"SELECT NAME for '%@'", cID]];
        return nil;
    }
}

-(NSString *) getDate {
    return nil;
}

-(NSNumber *) getBudget: (NSString *) date {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT Budget FROM BUDGET WHERE DATE = '%@'", date];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
    }
    else {
        //[self showErrMsg: [NSString stringWithFormat:@"SELECT Budget for '%@'", date]];
        return [NSNumber numberWithInt:0];
    }
}

-(NSNumber *) getTotal: (NSString *) date {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT sum(AMOUNT) FROM TRANSACTIONS WHERE TIME = '%@'", date];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
    }
    else {
        //[self showErrMsg: [NSString stringWithFormat:@"SELECT Budget for '%@'", date]];
        return [NSNumber numberWithInt:0];
    }
}

-(NSNumber *) getAmount: (NSString *) date andCID: (NSNumber *) cID {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT Amount FROM TRANSACTIONS WHERE TIME = '%@' AND cID = %@;", date, cID];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
    }
    else {
        [self showErrMsg: [NSString stringWithFormat:@"SELECT Amount for '%@' on %@", cID, date]];
        return nil;
    }
}

-(NSNumber *) getAmount: (NSString *) date andCategoryName: (NSString *) cName {
    return [self getAmount:date andCID:[self getCID:cName]];
}

-(NSMutableArray *) getCategories {
    NSMutableArray *categoryList = [[NSMutableArray alloc] init];
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT Name FROM CATEGORY;"];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    NSMutableString *categoryName = [[NSMutableString alloc] init];
    
    while (sqlite3_step(select) == SQLITE_ROW) {
        categoryName = [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)];
        [categoryList addObject:categoryName];
    }
    
    return categoryList;
}


//Close database
-(void) closeDB {
    sqlite3_close(ledgerDB);
}

-(void) showErrMsg: (NSString *) msg{
    NSLog(@"Error: failed to %@ due to %s", msg, sqlite3_errmsg(ledgerDB));
}

//for debugging
-(void) dropTable:(NSString *) tableName {
    char *error;
    NSString *drop_stmt = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    
    if (sqlite3_exec(ledgerDB, [drop_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"DROP %@ Table", tableName]];
        //NSLog(@"Error: failed to DROP %@ Table due to %s", tableName, sqlite3_errmsg(ledgerDB));
    }
}

//for debugging
-(void) insertDefaultRecords
{    
    /*
    [self insertCategory:@"Breakfast"];
    [self insertCategory:@"Lunch"];
    [self insertCategory:@"Dinner"];
    [self insertCategory:@"Transportation"];
    
    [self insertBudget:@"20121001" andBudget:[NSNumber numberWithFloat:30.0]];
    [self insertBudget:@"20121002" andBudget:[NSNumber numberWithFloat:30.0]];
    [self insertBudget:@"20121003" andBudget:[NSNumber numberWithFloat:50.0]];
    
    [self insertTransactions:@"20121001" andCID:[NSNumber numberWithInt:1] andAmount:[NSNumber numberWithFloat:12.9]];
    [self insertTransactions:@"20121001" andCID:[NSNumber numberWithInt:2] andAmount:[NSNumber numberWithFloat:7.95]];
    */
    //[self insertTransactions:@"20121002" andCID:[NSNumber numberWithInt:2] andAmount:[NSNumber numberWithFloat:15.93]];
    //[self insertTransactions:@"20121003" andCID:[NSNumber numberWithInt:3] andAmount:[NSNumber numberWithFloat:23.75]];
    
    //[self updateCategory:@"Transportation" andNewName:@"Gas"];
    //[self updateBudget:@"20121002" andBudget: [NSNumber numberWithFloat: 40]];
    //[self updateTransactions:@"20121001" andCID:[NSNumber numberWithInt: 2] andAmount: [NSNumber numberWithFloat: 9.75]];
    
    //failed insertions (invalid DATE)
    //[self insertTransactions:@"20001001" andCID:[NSNumber numberWithInt:1] andAmount:[NSNumber numberWithFloat:7.95]];
    //[self insertTransactions:@"20131001" andCID:[NSNumber numberWithInt:2] andAmount:[NSNumber numberWithFloat:7.95]];
    //failed insertions (invalid CID)
    //[self insertTransactions:@"20121001" andCID:[NSNumber numberWithInt:35] andAmount:[NSNumber numberWithFloat:7.95]];
    //failed insertions (invalid combination)
    //[self insertTransactions:@"20121001" andCID:[NSNumber numberWithInt:1] andAmount:[NSNumber numberWithFloat:7.95]];
    
}

//for debugging
-(void) display {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT * FROM TRANSACTIONS"];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    
    while (sqlite3_step(select) == SQLITE_ROW) {
        NSLog(@"\nC1\t\tC2\t\n%s\t%s\t", sqlite3_column_text(select, 0), sqlite3_column_text(select, 2));
    }
    NSLog(@"\nCATEGORIES:\n%@", [self getCategories]);
}


@end
