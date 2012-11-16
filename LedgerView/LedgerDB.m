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
    success = true;
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
    //NSLog (@"%@",[self getDate]);
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
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"INSERT %@ INTO CATEGORY TABLE", categoryName]];
    }
    else {
        success = true;
    }
}

-(void) insertBudget:(NSDate *) date andBudget:(NSNumber *) budget {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    char *error;
    NSString *insert_stmt =
    [NSString stringWithFormat:@"INSERT INTO BUDGET(DATE, BUDGET) VALUES ('%@', %f)", dateString, [budget doubleValue]];
    
    if ([self getBudget:date] == NULL) {
        if (sqlite3_exec(ledgerDB, [insert_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
            success = false;
            [self showErrMsg: [NSString stringWithFormat:@"INSERT %@ INTO BUDGET TABLE", budget]];
        }
        else {
            success = true;
        }
    }
}

-(void) insertTransactions:(NSDate *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) amount {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    char *error;
    NSString *insert_stmt =
    [NSString stringWithFormat:@"INSERT INTO TRANSACTIONS VALUES ('%@', %d, %f)", dateString, [cID integerValue], [amount doubleValue]];
    
    if (sqlite3_exec(ledgerDB, [insert_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"INSERT %@ INTO TRANSACTIONS TABLE", amount]];
    }
    else {
        success = true;
    }
}

//Update Records
-(void) updateCategory:(NSString *) oldCategoryName andNewName:(NSString *) newCategoryName{
    char *error;
    NSString *update_stmt =
    [NSString stringWithFormat:@"UPDATE CATEGORY SET NAME = '%@' WHERE NAME = '%@' ", newCategoryName, oldCategoryName];
    
    if (sqlite3_exec(ledgerDB, [update_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"UPDATE %@ in CATEGORY TABLE", newCategoryName]];
    }
    else {
        success = true;
    }
}

-(void) updateBudget:(NSDate *) date andBudget:(NSNumber *) newBudget {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    char *error;
    NSString *update_stmt =
    [NSString stringWithFormat:@"UPDATE BUDGET SET Budget = '%@' WHERE DATE = '%@' ", newBudget, dateString];
    
    if (sqlite3_exec(ledgerDB, [update_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        [self showErrMsg: [NSString stringWithFormat:@"UPDATE %@ in BUDGET TABLE", newBudget]];
        success = false;
    }
    else {
        success = true;
    }
}

-(void) updateTransactions:(NSDate *) date andCID: (NSNumber *) cID andAmount: (NSNumber *) newAmount {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    char *error;
    NSString *update_stmt =
    [NSString stringWithFormat:@"UPDATE TRANSACTIONS SET Amount = '%f' WHERE TIME = '%@' AND cID = '%@'", [newAmount doubleValue], dateString, cID];
    
    if (sqlite3_exec(ledgerDB, [update_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"UPDATE %@ in TRANSACTIONS TABLE", newAmount]];
    }
    else {
        success = true;
    }
}

//Delete Records
-(void) deleteCategory:(NSString *) categoryName {
    char *error;
    
    NSString *delete_transactions_stmt =
    [NSString stringWithFormat:@"DELETE FROM TRANSACTIONS WHERE cID = '%@'", [self getCID:categoryName]];
    if (sqlite3_exec(ledgerDB, [delete_transactions_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"DELETE CATEGORY %@ FROM TRANSACTIONS TABLE", categoryName]];
    }
    else {
        NSString *delete_stmt =
        [NSString stringWithFormat:@"DELETE FROM CATEGORY WHERE NAME = '%@'", categoryName];
        
        if (sqlite3_exec(ledgerDB, [delete_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
            success = false;
            [self showErrMsg: [NSString stringWithFormat:@"DELETE %@ FROM CATEGORY TABLE", categoryName]];
        }
        else {
            success = true;
        }
    }
    
}

-(void) deleteBudget:(NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    char *error;
    NSString *delete_stmt =
    [NSString stringWithFormat:@"DELETE FROM Budget WHERE Date = '%@'", dateString];
    
    if (sqlite3_exec(ledgerDB, [delete_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"DELETE Budget on %@ FROM Budget TABLE", dateString]];
    }
    else {
        success = true;
    }
}

-(void) deleteTransactions:(NSDate *) date andCID: (NSNumber *) cID {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    char *error;
    NSString *delete_stmt =
    [NSString stringWithFormat:@"DELETE FROM TRANSACTIONS WHERE TIME = '%@' AND cID = '%@'", dateString, cID];
    
    if (sqlite3_exec(ledgerDB, [delete_stmt UTF8String], NULL, NULL, &error) != SQLITE_OK) {
        success = false;
        [self showErrMsg: [NSString stringWithFormat:@"DELETE Transaction %@ on %@ FROM CATEGORY TABLE", cID, dateString]];
    }
    else {
        success = true;
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
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateToday = [dateFormat stringFromDate:[NSDate date]];

    return dateToday;
}

-(NSNumber *) getBudget: (NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT Budget FROM BUDGET WHERE DATE = '%@'", dateString];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
    }
    else {
        //[self showErrMsg: [NSString stringWithFormat:@"SELECT Budget for '%@'", date]];
        return NULL;//[NSNumber numberWithInt:0];
    }
}

-(NSNumber *) getTotal: (NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT sum(AMOUNT) FROM TRANSACTIONS WHERE TIME = '%@'", dateString];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
    }
    else {
        //[self showErrMsg: [NSString stringWithFormat:@"SELECT Budget for '%@'", date]];
        return [NSNumber numberWithInt:0];
    }
}

-(NSMutableDictionary *) getTransactions: (NSDate *) date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    NSMutableDictionary *transactionList = [[NSMutableDictionary alloc] init];
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT Amount, Name FROM TRANSACTIONS T, CATEGORY C WHERE T.TIME = '%@' AND T.cID = C.cID;", dateString];
    NSNumber *amount = [[NSNumber alloc] init];
    NSString *cName = [[NSString alloc] init];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    
    while (sqlite3_step(select) == SQLITE_ROW) {
        amount = [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
        cName = [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)];
        [transactionList setObject:amount forKey:cName];
    }
    return transactionList;
}

-(NSNumber *) getAmount: (NSDate *) date andCID: (NSNumber *) cID {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormat stringFromDate: date];
    
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT Amount FROM TRANSACTIONS WHERE TIME = '%@' AND cID = %@;", dateString, cID];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    if (sqlite3_step(select) == SQLITE_ROW) {
        return [NSNumber numberWithFloat: sqlite3_column_double(select, 0)];
    }
    else {
        [self showErrMsg: [NSString stringWithFormat:@"SELECT Amount for '%@' on %@", cID, date]];
        return nil;
    }
}

-(NSNumber *) getAmount: (NSDate *) date andCategoryName: (NSString *) cName {
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

// databases status
-(BOOL) succeed {
    return success;
}
-(NSString *) errMsg {
    return nil;
}



//for debugging
-(void) display {
    sqlite3_stmt *select = nil;
    NSString *select_stmt = [NSString stringWithFormat:@"SELECT * FROM TRANSACTIONS"];
    sqlite3_prepare_v2(ledgerDB, [select_stmt UTF8String], -1, &select, NULL);
    
    while (sqlite3_step(select) == SQLITE_ROW) {
        NSLog(@"\nC1\t\tC2\t\n%s\t%s\t", sqlite3_column_text(select, 0), sqlite3_column_text(select, 2));
    }
    //NSLog(@"\nTRANSACTIONS:\n%@", [self getCategories]);
}


@end
