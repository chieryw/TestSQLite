//
//  ViewController.m
//  TestSQLite
//
//  Created by chiery on 16/5/12.
//  Copyright © 2016年 My-Zone. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)createSQLAction:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
     // 创建数据库用时
     lastTime = CFAbsoluteTimeGetCurrent();
     for (NSInteger i = 0; i < KRunTimes; ++i) {
         FMDatabase *db = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%ld.db",(long)i]];
     }
     
     curTime = CFAbsoluteTimeGetCurrent();
     NSLog(@"创建数据库用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)createSimpleTableAction:(id)sender {
    
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:[NSString stringWithFormat:@"create table test%ld (a text)",(long)i]];
    }
    [db commit];
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"创建数据库简单表格用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)createComplexTableAction:(id)sender {
    
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:[NSString stringWithFormat:@"create table test%ld (a text,b integer,c text,d double,e data,f text,g data)",(long)i]];
    }
    [db commit];
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"创建数据库复杂表格用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)insertSimpleValueAction:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
     NSString *dbPath = @"/tmp/tmp.db";
     
     // delete the old db.
     NSFileManager *fileManager = [NSFileManager defaultManager];
     [fileManager removeItemAtPath:dbPath error:nil];
     
     FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
     
     if (![db open]) {
     NSLog(@"Could not open db.");
     }
     
     // kind of experimentalish.
     [db setShouldCacheStatements:YES];
     [db beginTransaction];
     [db executeUpdate:@"create table test (a text)"];
     
     lastTime = CFAbsoluteTimeGetCurrent();
     for (NSInteger i = 0; i < KRunTimes; ++i) {
     [db executeUpdate:@"insert into test (a) values (?)" ,
     @"hi'"];
     
     }
     [db commit];
     [db close];
     curTime = CFAbsoluteTimeGetCurrent();
     NSLog(@"插入一条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)insert7SimpleValues:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text,b integer,c text,d text,e integer,f text,g integer)"];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:@"insert into test (a, b, c, d, e, f, g) values (?, ?, ?, ?, ?, ?, ?)" ,
         @"hi'", // look!  I put in a ', and I'm not escaping it!
         [NSString stringWithFormat:@"number %ld", (long)i],
         [NSNumber numberWithInteger:i],
         @"hello",
         [NSNumber numberWithFloat:2.2f],
         @"world",
         [NSNumber numberWithDouble:4.4444]];
        
    }
    [db commit];
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"插入7条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)insert7ComplexValues:(id)sender {
    
    const NSInteger KRunTimes = 10 * 10;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a blob,b blob,c blob,d blob,e blob,f blob,g blob)"];
    
    // 将要存储的数据
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liushishi" ofType:@"png"]];
    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tempString" ofType:@"html"]];
    
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:@"insert into test (a, b, c, d, e, f, g) values (?, ?, ?, ?, ?, ?, ?)" ,
         imageData,imageData,imageData,imageData,fileData,fileData,fileData];
        
    }
    [db commit];
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"插入7条复杂数据用时: %f ms", (curTime - lastTime) * 1000);
    
}

- (IBAction)readSimpleValue:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text)"];
    [db executeUpdate:@"insert into test (a) values (?)" ,
     @"hi'"];
    [db commit];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        FMResultSet *rs = [db executeQuery:@"select * from test where a = ?", @"hi'"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"读取一条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)read7SimpleValues:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text,b integer,c text,d text,e integer,f text,g integer)"];
    [db executeUpdate:@"insert into test (a, b, c, d, e, f, g) values (?, ?, ?, ?, ?, ?, ?)" ,
     @"hi'", // look!  I put in a ', and I'm not escaping it!
     [NSString stringWithFormat:@"number %ld", (long)1],
     [NSNumber numberWithInteger:1],
     @"hello",
     [NSNumber numberWithFloat:2.2f],
     @"world",
     [NSNumber numberWithDouble:4.4444]];
    [db commit];

    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        FMResultSet *rs = [db executeQuery:@"select * from test where a = ?", @"hi'"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"读取7条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)read7ComplexValues:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a blob,b blob,c blob,d blob,e blob,f blob,g blob)"];
    
    // 将要存储的数据
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liushishi" ofType:@"png"]];
    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tempString" ofType:@"html"]];
    
    [db executeUpdate:@"insert into test (a, b, c, d, e, f, g) values (?, ?, ?, ?, ?, ?, ?)" ,
     imageData,imageData,imageData,imageData,fileData,fileData,fileData];
    
    [db commit];
    
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        FMResultSet *rs = [db executeQuery:@"select * from test where a = ?", @"hi'"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"读取7条复杂数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)updateSimpleValue:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text)"];
    [db executeUpdate:@"insert into test (a) values (?)" ,
     @"hi'"];
    [db commit];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeQuery:@"update test set a = ? where a = ?",@"hello,world", @"hi'"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"更新一条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)update7SimpleValues:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text,b integer,c text,d text,e integer,f text,g integer)"];
    [db executeUpdate:@"insert into test (a, b, c, d, e, f, g) values (?, ?, ?, ?, ?, ?, ?)" ,
     @"hi'", // look!  I put in a ', and I'm not escaping it!
     [NSString stringWithFormat:@"number %ld", (long)1],
     [NSNumber numberWithInteger:1],
     @"hello",
     [NSNumber numberWithFloat:2.2f],
     @"world",
     [NSNumber numberWithDouble:4.4444]];
    [db commit];
    
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeQuery:@"update test set a = ?,b = ?,c = ?,d = ?,e = ?,f = ?,g = ? where a = ?",@"hello,world", @"hello,world",@"hello,world",@"hello,world",@"hello,world",@"hello,world",@"hello,world",@"hi'"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"更新7条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)update7ComplexValues:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a blob,b blob,c blob,d blob,e blob,f blob,g blob,h text)"];
    
    // 将要存储的数据
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liushishi" ofType:@"png"]];
    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tempString" ofType:@"html"]];
    
    [db executeUpdate:@"insert into test (a, b, c, d, e, f, g, h) values (?, ?, ?, ?, ?, ?, ?, ?)" ,
     imageData,imageData,imageData,imageData,fileData,fileData,fileData,@"A"];
    
    [db commit];
    
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeQuery:@"update test set a = ?,b = ?,c = ?,d = ?,e = ?,f = ?,g = ? where h = ?",fileData,fileData,fileData,fileData,imageData,imageData,imageData, @"A"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"更新7条复杂数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)deleteSimpleValue:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text)"];
    
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:@"insert into test (a) values (?)" ,@"hi'"];
    }
    [db commit];
    [db beginTransaction];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeQuery:@"delete from test where a = ?", @"hi'"];
    }
    [db commit];
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"删除一条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)delete7SimpleValues:(id)sender {
    const NSInteger KRunTimes = 100 * 100;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a text,b integer,c text,d text,e integer,f text,g integer)"];
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:@"insert into test (a, b, c, d, e, f, g) values (?, ?, ?, ?, ?, ?, ?)" ,
         @"hi'", // look!  I put in a ', and I'm not escaping it!
         [NSString stringWithFormat:@"number %ld", (long)1],
         [NSNumber numberWithInteger:1],
         @"hello",
         [NSNumber numberWithFloat:2.2f],
         @"world",
         [NSNumber numberWithDouble:4.4444]];
    }
    
    [db commit];
    [db beginTransaction];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeQuery:@"delete from test where a = ?", @"hi'"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"删除7条简单数据用时: %f ms", (curTime - lastTime) * 1000);
}

- (IBAction)delete7ComplexValues:(id)sender {
    const NSInteger KRunTimes = 10 * 10;
    double curTime, lastTime;
    
    NSString *dbPath = @"/tmp/tmp.db";
    
    // delete the old db.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:dbPath error:nil];
    
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    if (![db open]) {
        NSLog(@"Could not open db.");
    }
    
    // kind of experimentalish.
    [db setShouldCacheStatements:YES];
    [db beginTransaction];
    [db executeUpdate:@"create table test (a blob,b blob,c blob,d blob,e blob,f blob,g blob,h text)"];
    
    // 将要存储的数据
    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"liushishi" ofType:@"png"]];
    NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tempString" ofType:@"html"]];
    
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeUpdate:@"insert into test (a, b, c, d, e, f, g, h) values (?, ?, ?, ?, ?, ?, ?, ?)" ,imageData,imageData,imageData,imageData,fileData,fileData,fileData,@"A"];
    }
    [db commit];
    [db beginTransaction];
    
    lastTime = CFAbsoluteTimeGetCurrent();
    for (NSInteger i = 0; i < KRunTimes; ++i) {
        [db executeQuery:@"delete from test where h = ?", @"A"];
    }
    [db close];
    curTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"删除7条复杂数据用时: %f ms", (curTime - lastTime) * 1000);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
