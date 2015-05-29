

#import "SqliteCore.h"
#import <sqlite3.h>

//#define dataBaseName           @"dataBase.sqlite"


sqlite3 *mydb;
@implementation SqliteCore

//保存文件
//@param   name    保存的文件名
//@param   fileData    文件数据
+ (BOOL)saveFileWithName:(NSString *)name andData:(NSData *)fileData
{
    // 文件下载路径修改 begin
    NSArray	*documentPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *doc=[documentPaths  objectAtIndex:0];
    
    NSString *filePath=[doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    // // 文件下载路径修改 end
    
    NSLog(@"222 %@",filePath);
    BOOL isSuccess=[fileData writeToFile:filePath atomically:YES];
    return isSuccess;
}

//读取文件
//@param   name    文件名
//@return   文件数据
+ (NSData *)readFileFormName:(NSString *)name
{
    // 文件读取路径修改 begin
    NSArray	*documentPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *doc=[documentPaths  objectAtIndex:0];
    
    NSString *filePath=[doc stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",name]];
    // 文件读取路径修改 end
    
    NSData *readData=[NSData dataWithContentsOfFile:filePath];
    return readData;
}

//判断数据文件是否在沙盒中，如果不存在就将数据库文件复制到沙盒中

//判断文件是否存在
//@param    nameString  需要判断的文件名，需要带后缀名
//@return    yes or no
+ (BOOL) copyDatabaseIfNeeded:(NSString *)nameString 
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:nameString];;
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(!success) { //如果不存在就创建文件
        success=[fileManager createFileAtPath:dbPath contents:nil attributes:nil];
//        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dataBaseName];
//        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
    }
    return success;
}

//删除沙盒文件
//@param    nameString  需要判断的文件名，需要带后缀名
//@return    yes or no
+ (BOOL) deleteDatabaseIfNeeded:(NSString *)nameString 
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:nameString];;
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    if(success) {
        success = [fileManager removeItemAtPath:nameString error:&error];
        NSLog(@"error=%@",error);
        return success;
    }
    return NO;
}

//打开数据库文件
//@param    nameString  需要打开的数据库文件名，需要带后缀名
//@return    yes or no
+ (BOOL)opensqlite:(NSString *)nameString
{
    BOOL find=[SqliteCore copyDatabaseIfNeeded:nameString];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *myPath = [documentsDir stringByAppendingPathComponent:nameString];;
    if (find) {
        if(sqlite3_open([myPath UTF8String],&mydb)==SQLITE_OK)
        {
            return YES;
        }
        else if(sqlite3_open([myPath UTF8String],&mydb) != SQLITE_OK) {
            sqlite3_close(mydb);
            NSLog(@"Error: open database file.");
            return NO;
        }
    }
    return NO;
}
/*判断数据库中是否存在这张表
 *@param   dbName    数据库文件名
 *@param   tableName  表名
 */
+ (BOOL)tableIsHas:(NSString *)dbName andTableName:(NSString *)tableName
{
    if ([SqliteCore opensqlite:dbName]) {
        NSString *sql_string=[NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type=table AND name=%@",tableName];
        NSLog(@"sqlstring=%@",sql_string);
        const char *sql=[sql_string UTF8String];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(mydb, sql, -1, &statement, nil) != SQLITE_OK) {
            sqlite3_close(mydb);
            return NO;
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if ( success != SQLITE_DONE) {
            sqlite3_close(mydb);
            return NO;
        }
        sqlite3_close(mydb);
        return YES;
    }
    return NO;
}


//创建表
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param   arr     字段数组
+ (BOOL)createTable:(NSString *)dbName 
       andTableName:(NSString *)tableName 
           withData:(NSArray *)arr
{
    if ([SqliteCore opensqlite:dbName]) {
        NSString *sqlString=@"";
        for (int i=0; i<[arr count]; i++) {
            if (i==0) {
                sqlString=[sqlString stringByAppendingFormat:@"%@ text",[arr objectAtIndex:i]];
            }
            else {
                sqlString=[sqlString stringByAppendingFormat:@",%@ text",[arr objectAtIndex:i]];
            }
        }
        NSString *sql_string=[NSString stringWithFormat:@"create table if not exists %@ (%@)",tableName, sqlString];
        NSLog(@"sqlstring=%@",sql_string);
        const char *sql=[sql_string UTF8String];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(mydb, sql, -1, &statement, nil) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:create fields table");
            sqlite3_close(mydb);
            return NO;
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:CREATE TABLE fields");
            sqlite3_close(mydb);
            return NO;
        }
        NSLog(@"Create table 'channels' successed.");
        sqlite3_close(mydb);
        return YES;
    }
    return NO;
}

//删除表
//@param   dbName    数据库文件名
//@param   tableName  表名
+ (BOOL)dropTable:(NSString *)dbName
     andTableName:(NSString *)tableName
{
    if ([SqliteCore opensqlite:dbName]) {
        NSString *sql_string=[NSString stringWithFormat:@"drop table %@",tableName];
        NSLog(@"sqlstring=%@",sql_string);
        const char *sql=[sql_string UTF8String];
        sqlite3_stmt *statement;
        if(sqlite3_prepare_v2(mydb, sql, -1, &statement, nil) != SQLITE_OK) {
            sqlite3_close(mydb);
            return NO;
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if ( success != SQLITE_DONE) {
            sqlite3_close(mydb);
            return NO;
        }
        sqlite3_close(mydb);
        return YES;
    }
    return NO;
}

//插入数据
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param   dict     字段和值对应的词典
+ (BOOL)insertMainTable:(NSString *)dbName 
           andTableName:(NSString *)tableName
                andData:(NSDictionary *)dict
{
    if ([SqliteCore opensqlite:dbName]) {
        NSString *nameString=@"";
        NSString *valueString=@"";
        NSArray *keyArr=[dict allKeys];
        for (int i=0; i<[keyArr count]; i++) {
            if (i==0) {
                nameString=[nameString stringByAppendingFormat:@"%@",[keyArr objectAtIndex:i]];
                valueString=[valueString stringByAppendingFormat:@"\'%@\'",[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
            else {
                nameString=[nameString stringByAppendingFormat:@",%@",[keyArr objectAtIndex:i]];
                valueString=[valueString stringByAppendingFormat:@",\'%@\'",[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
        }
        sqlite3_stmt *statement;
        NSString *sqlString=[NSString stringWithFormat:@"INSERT INTO %@(%@) values (%@)",tableName,nameString,valueString];
        NSLog(@"sqlstring==%@",sqlString);
        const char *sql = [sqlString UTF8String];
        int success = sqlite3_prepare_v2(mydb, sql, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to insert:fields");
            sqlite3_close(mydb);
            return NO;
        }
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database with message.");
            sqlite3_close(mydb);
            return NO;
        } 
        sqlite3_close(mydb);
        return YES;
    }
    return NO;
}
//从表中读取数据
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param   arr     字段数组
//@param  dict     搜索条件的词典
//@param  sortingDict  排序字段以及对应的排序值（desc or asc)
//@param  num   获取数据的条数
+ (NSMutableArray *)checkIfHasUser:(NSString *)dbName
                            andTableName:(NSString *)tableName 
                                 andData:(NSArray *)arrary 
                              withSearch:(NSDictionary *)dict
                              andSorting:(NSDictionary *)sortingDict
                                andLimit:(int)num
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    if ([SqliteCore opensqlite:dbName]) {
        NSString *nameString=@"";
        for (int i=0; i<[arrary count]; i++) {
            if (i==0) {
                nameString=[nameString stringByAppendingFormat:@"%@",[arrary objectAtIndex:i]];
            }
            else
            {
                nameString=[nameString stringByAppendingFormat:@",%@",[arrary objectAtIndex:i]];
            }
        }
        
        if (arrary.count==0) {
            nameString=@"*";
        }
        
        NSArray *keyArr=[dict allKeys];
        NSString *searchString=@"";
        for (int i=0; i<[keyArr count]; i++) {
            if (i==0) {
                searchString=[searchString stringByAppendingFormat:@"%@=\'%@\'",[keyArr objectAtIndex:i],[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
            else
            {
                searchString=[searchString stringByAppendingFormat:@" and %@=\'%@\'",[keyArr objectAtIndex:i],[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
        }
        NSString *sqlString=nil;
        if ([keyArr count]>0) {
            sqlString =[NSString stringWithFormat:@"select %@ from %@ where %@",nameString,tableName,searchString];
        }
        else
        {
            sqlString =[NSString stringWithFormat:@"select %@ from %@",nameString,tableName];
        }
        
        NSArray *sortingKey=[sortingDict allKeys];
        for (int i=0; i<sortingKey.count; i++) {
            sqlString=[sqlString stringByAppendingFormat:@"order by %@ %@",[sortingKey objectAtIndex:i],[sortingDict objectForKey:[sortingKey objectAtIndex:i]]];
        }
        if (num>0) {
            sqlString=[sqlString stringByAppendingFormat:@"limit %d",num];
        }
        
        NSLog(@"sqlstring=%@",sqlString);
        sqlite3_stmt *statement; 
        const char *searchSQL=[sqlString UTF8String];
        if(sqlite3_prepare_v2(mydb,searchSQL,-1,&statement,nil)==SQLITE_OK) 
        { 
            while(sqlite3_step(statement) == SQLITE_ROW) 
            {
                NSMutableDictionary *seachDict=[[NSMutableDictionary alloc] init];
                for (int i=0; i<[arrary count]; i++) {
                    char* seachChar = (char*)sqlite3_column_text(statement,i);
                    NSString *seachString;
                    if (seachChar!=nil) {
                        seachString = [[NSString alloc] initWithUTF8String:seachChar];
                    }
                    else{
                        seachString=[[NSString alloc] init];
                    }
                    [seachDict setObject:seachString forKey:[arrary objectAtIndex:i]];
#if !__has_feature(objc_arc)
                    [seachString release];
#endif
                }
                [arr addObject:seachDict];
#if !__has_feature(objc_arc)
                [seachDict release];
#endif
            } 
            sqlite3_finalize(statement);
        }
        sqlite3_close(mydb);
    }
#if !__has_feature(objc_arc)
    return [arr autorelease];
#else
    return arr;
#endif
} 

//从表中读取数据  like查找方式
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param   arr     字段数组
//@param  dict     搜索条件的词典
//@param  sortingDict  排序字段以及对应的排序值（desc or asc)
//@param  num   获取数据的条数
+ (NSMutableArray *)searchTableWith:(NSString *)dbName
                             andTableName:(NSString *)tableName 
                                  andData:(NSArray *)arrary 
                               withSearch:(NSDictionary *)dict
                               andSorting:(NSDictionary *)sortingDict
                                 andLimit:(int)num
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    if ([SqliteCore opensqlite:dbName]) {
        NSString *nameString=@"";
        for (int i=0; i<[arrary count]; i++) {
            if (i==0) {
                nameString=[nameString stringByAppendingFormat:@"%@",[arrary objectAtIndex:i]];
            }
            else
            {
                nameString=[nameString stringByAppendingFormat:@",%@",[arrary objectAtIndex:i]];
            }
        }
        
        if (arrary.count==0) {
            nameString=@"*";
        }
        
        NSArray *keyArr=[dict allKeys];
        NSString *searchString=@"";
        for (int i=0; i<[keyArr count]; i++) {
            if (i==0) {
                searchString=[searchString stringByAppendingFormat:@"%@ like \'%@\'",[keyArr objectAtIndex:i],[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
            else
            {
                searchString=[searchString stringByAppendingFormat:@" and %@ liek \'%@\'",[keyArr objectAtIndex:i],[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
        }
        NSString *sqlString;
        if ([keyArr count]>0) {
            sqlString =[NSString stringWithFormat:@"select %@ from %@ where %@",nameString,tableName,searchString];
        }
        else
        {
            sqlString =[NSString stringWithFormat:@"select %@ from %@",nameString,tableName];
        }
        
        NSArray *sortingKey=[sortingDict allKeys];
        for (int i=0; i<sortingKey.count; i++) {
            sqlString=[sqlString stringByAppendingFormat:@"order by %@ %@",[sortingKey objectAtIndex:i],[sortingDict objectForKey:[sortingKey objectAtIndex:i]]];
        }
        if (num>0) {
            sqlString=[sqlString stringByAppendingFormat:@"limit %d",num];
        }
        
        NSLog(@"sqlstring=%@",sqlString);
        sqlite3_stmt *statement; 
        const char *searchSQL=[sqlString UTF8String];
        if(sqlite3_prepare_v2(mydb,searchSQL,-1,&statement,nil)==SQLITE_OK) 
        { 
            while(sqlite3_step(statement) == SQLITE_ROW) 
            {
                NSMutableDictionary *seachDict=[[NSMutableDictionary alloc] init];
                for (int i=0; i<[arrary count]; i++) {
                    char* seachChar = (char*)sqlite3_column_text(statement,i);
                    NSString *seachString;
                    if (seachChar!=nil) {
                        seachString = [[NSString alloc] initWithUTF8String:seachChar];
                    }
                    else{
                        seachString=[[NSString alloc] init];
                    }
                    [seachDict setObject:seachString forKey:[arrary objectAtIndex:i]];
#if !__has_feature(objc_arc)
                    [seachString release];
#endif
                }
                [arr addObject:seachDict];
#if !__has_feature(objc_arc)
                [seachDict release];
#endif
            } 
            sqlite3_finalize(statement);
        }
        sqlite3_close(mydb);
    }
#if !__has_feature(objc_arc)
    return [arr autorelease];
#else
    return arr;
#endif
}

//修改数据
//@param   dbName        数据库文件名
//@param   tableName        表名
//@param   keyDictionary    要修改的字段和值对应的词典。
//@param   whereDictionary  用于查寻的字段和值对应的词典。
+ (BOOL) updateSqliteMainTable:(NSString *)dbName
                    tableName:(NSString *)tableName 
                keyDictionary:(NSDictionary *)keyDictionary 
              whereDictionary:(NSDictionary *)whereDictionary
{
    if ([SqliteCore opensqlite:dbName]) {
        NSArray *keyArray=[keyDictionary allKeys];
        NSString *keyString=@"";
        for (int i=0; i<[keyArray count]; i++) {
            if (i==0) {
                keyString=[keyString stringByAppendingFormat:@"%@=\'%@\'",[keyArray objectAtIndex:i],[keyDictionary objectForKey:[keyArray objectAtIndex:i]]];
            }
            else
            {
                keyString=[keyString stringByAppendingFormat:@", %@=\'%@\'",[keyArray objectAtIndex:i],[keyDictionary objectForKey:[keyArray objectAtIndex:i]]];
            }
        }
        
        
        NSArray *whereArray=[whereDictionary allKeys];
        NSString *whereString=@"";
        for (int i=0; i<[whereArray count]; i++) {
            if (i==0) {
                whereString=[whereString stringByAppendingFormat:@"%@=\'%@\'",[whereArray objectAtIndex:i],[whereDictionary objectForKey:[whereArray objectAtIndex:i]]];
            }
            else
            {
                whereString=[whereString stringByAppendingFormat:@" and %@=\'%@\'",[whereArray objectAtIndex:i],[whereDictionary objectForKey:[whereArray objectAtIndex:i]]];
            }
        }
        sqlite3_stmt *statement;
        NSString *updateString;
        if ([whereArray count]>0) {
            updateString =[NSString stringWithFormat:@"UPDATE %@ SET %@ where %@",tableName,keyString,whereString];
        }
        else
        {
            updateString =[NSString stringWithFormat:@"UPDATE %@ SET %@",tableName,keyString];
        }
        const char *updateSQL=[updateString UTF8String];
        if(sqlite3_prepare_v2(mydb, updateSQL, -1, &statement, nil) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:delete userid 0");
            sqlite3_close(mydb);
            return NO;
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:delete userid 0");
            sqlite3_close(mydb);
            return NO;
        }
        NSLog(@"Create table 'channels' successed.");
        sqlite3_close(mydb);
        return YES;
    }
    return NO;
}
//从表中删除数据
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param  dict     搜索条件的词典
+ (BOOL)deleteData:(NSString *)dbName 
    andTableName:(NSString *)tableName 
        withSearch:(NSDictionary *)dict
{
    if ([SqliteCore opensqlite:dbName]) {
        
        NSArray *keyArr=[dict allKeys];
        NSString *searchString=@"";
        for (int i=0; i<[keyArr count]; i++) {
            if (i==0) {
                searchString=[searchString stringByAppendingFormat:@"%@=\'%@\'",[keyArr objectAtIndex:i],[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
            else
            {
                searchString=[searchString stringByAppendingFormat:@" and %@=\'%@\'",[keyArr objectAtIndex:i],[dict objectForKey:[keyArr objectAtIndex:i]]];
            }
        }
        sqlite3_stmt *statement;
        NSString *deleteString;
        if ([keyArr count]>0) {
            //Henry 加了一个%@, 解决 searchString not used by sql 语句。
            deleteString = [NSString stringWithFormat:@"delete from %@ where %@",tableName,searchString];
        }
        else
        {
            deleteString = [NSString stringWithFormat:@"delete from %@",tableName];
        }
        NSLog(@"delete=%@",deleteString);
        const char *deleteSQL=[deleteString UTF8String];
        if(sqlite3_prepare_v2(mydb, deleteSQL, -1, &statement, nil) != SQLITE_OK) {
            NSLog(@"Error: failed to prepare statement:delete userid 0");
            sqlite3_close(mydb);
            return NO;
        }
        int success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if ( success != SQLITE_DONE) {
            NSLog(@"Error: failed to dehydrate:delete userid 0");
            sqlite3_close(mydb);
            return NO;
        }
        NSLog(@"Create table 'channels' successed.");
        sqlite3_close(mydb);
        return YES;
    }
    return NO;
} 

//判断数据是否存在
//@param   mainTable        数据库文件名
//@param   tableName        表名
//@param   whereDictionary  用于查寻的字段和值对应的词典。
+ (BOOL) determiningSqliteMainTable:(NSString *)dbName
                         tableName:(NSString *)tableName 
                   whereDictionary:(NSDictionary *)whereDictionary
{
    if ([SqliteCore opensqlite:dbName]) 
    {
        NSArray *keyArr=[whereDictionary allKeys];
        NSString *searchString=@"";
        for (int i=0; i<[keyArr count]; i++) {
            
            if (i==0) {
                searchString=[searchString stringByAppendingFormat:@"%@=\'%@\'",[keyArr objectAtIndex:i],[whereDictionary objectForKey:[keyArr objectAtIndex:i]]];
            }
            else
            {
                searchString=[searchString stringByAppendingFormat:@" and %@=\'%@\'",[keyArr objectAtIndex:i],[whereDictionary objectForKey:[keyArr objectAtIndex:i]]];
            }
            
        }
        NSString *sqlString;
        if ([keyArr count]>0) {
            sqlString =[NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@ where %@",tableName,searchString];
        }
        else
        {
            sqlString =[NSString stringWithFormat:@"SELECT COUNT(*) AS count FROM %@",tableName];
        }
        
        sqlite3_stmt *statement; 
        const char *searchSQL=[sqlString UTF8String];
        if(sqlite3_prepare_v2(mydb,searchSQL,-1,&statement,nil)==SQLITE_OK) 
        { 
            while(sqlite3_step(statement) == SQLITE_ROW) 
            {
                int seachNumber = sqlite3_column_int(statement, 0);
                if (seachNumber>0) {
                    sqlite3_close(mydb);
                    return YES;
                }
            } 
            sqlite3_finalize(statement); 
        }
        sqlite3_close(mydb);
    }
    return NO;
}

@end
