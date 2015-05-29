

#import <UIKit/UIKit.h>

@interface SqliteCore : NSObject

//判断数据文件是否在沙盒中，如果不存在就将数据库文件复制到沙盒中

//判断文件是否存在
//@param    nameString  需要判断的文件名，需要带后缀名
//@return    yes or no
+ (BOOL) copyDatabaseIfNeeded:(NSString *)nameString;

//保存文件
//@param   name    保存的文件名
//@param   fileData    文件数据
+ (BOOL)saveFileWithName:(NSString *)name andData:(NSData *)fileData;

//读取文件
//@param   name    文件名
//@return   文件数据
+ (NSData *)readFileFormName:(NSString *)name;

//删除沙盒文件
//@param    nameString  需要判断的文件名，需要带后缀名
//@return    yes or no
+ (BOOL) deleteDatabaseIfNeeded:(NSString *)nameString;

//打开数据库文件
//@param    nameString  需要打开的数据库文件名，需要带后缀名
//@return    yes or no
+ (BOOL)opensqlite:(NSString *)nameString;

/*判断数据库中是否存在这张表
 *@param   dbName    数据库文件名
 *@param   tableName  表名
 */
+ (BOOL)tableIsHas:(NSString *)dbName andTableName:(NSString *)tableName;

//创建表
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param   arr     字段数组
+ (BOOL)createTable:(NSString *)dbName 
       andTableName:(NSString *)tableName 
           withData:(NSArray *)arr;

//删除表
//@param   dbName    数据库文件名
//@param   tableName  表名
+ (BOOL)dropTable:(NSString *)dbName
     andTableName:(NSString *)tableName;

//插入数据
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param   dict     字段和值对应的词典
+ (BOOL)insertMainTable:(NSString *)dbName 
           andTableName:(NSString *)tableName 
                andData:(NSDictionary *)dict;

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
                                andLimit:(int)num;

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
                                 andLimit:(int)num;

//修改数据
//@param   dbName        数据库文件名
//@param   tableName        表名
//@param   keyDictionary    要修改的字段和值对应的词典。
//@param   whereDictionary  用于查寻的字段和值对应的词典。
+ (BOOL) updateSqliteMainTable:(NSString *)dbName
                     tableName:(NSString *)tableName 
                 keyDictionary:(NSDictionary *)keyDictionary 
               whereDictionary:(NSDictionary *)whereDictionary;

//从表中删除数据
//@param   dbName    数据库文件名
//@param   tableName  表名
//@param  dict     搜索条件的词典
+ (BOOL)deleteData:(NSString *)dbName 
      andTableName:(NSString *)tableName 
        withSearch:(NSDictionary *)dict;

//判断数据是否存在
//@param   mainTable        数据库文件名
//@param   tableName        表名
//@param   whereDictionary  用于查寻的字段和值对应的词典。
+ (BOOL) determiningSqliteMainTable:(NSString *)dbName
                          tableName:(NSString *)tableName 
                    whereDictionary:(NSDictionary *)whereDictionary;



@end
