//
//  ViewController.m
//  tongxunluFMDB
//
//  Created by mac on 17/11/19.
//  Copyright (c) 2017年 mac. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "addViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    FMDatabase *_DB;
}
@property (nonatomic,retain) UITableView *table;
@property (nonatomic,retain) NSMutableArray *ID;
@property (nonatomic,retain) NSMutableArray *Name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@",NSHomeDirectory());
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNav];
    
    [self createDataBase];
    
    [self createTable];
}
- (BOOL)openDataBase{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"dataBase.sqlite"];
    if (!_DB) {
        _DB = [[FMDatabase alloc]initWithPath:filePath];
    }
    return [_DB open];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    addViewController *addVC = [[addViewController alloc]init];
    addVC.name = _Name[indexPath.row];
    addVC.ID = (int)[tableView cellForRowAtIndexPath:indexPath].tag;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)createDataBase{
    if ([self openDataBase]) {
        if ([_DB executeUpdate:@"create table if not exists People (id integer primary key autoincrement not null ,name text) "]) {
            NSLog(@"create People success");
        }else{
            NSLog(@"create People fail");
        }
        if ([_DB executeUpdate:@"create table if not exists Phone (id integer primary key autoincrement , iddd integer ,number integer)"]) {
            NSLog(@"create Phone success");
        }else{
            NSLog(@"create Phone fail");
        }
        
        [_DB close];
    }else{
        NSLog(@"open DB fail");
    }
}

- (void)setNav{
    
    self.title = @"通讯录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    
}
- (void)rightBtnClick{
    addViewController *addVC = [[addViewController alloc]init];
    addVC.ID = -1;
    [self.navigationController pushViewController:addVC animated:YES];
}
- (void)reloadTable{
    if ([self openDataBase]) {
        NSMutableArray *ID = [[NSMutableArray alloc]init];
        NSMutableArray *Name = [[NSMutableArray alloc]init];
        FMResultSet *set = [_DB executeQuery:@"select * from People"];
        while ([set next]) {
            [ID addObject:@([set intForColumnIndex:0])];
            [Name addObject:[set stringForColumnIndex:1]];
        }
        _ID = ID;
        _Name = Name;
        [_table reloadData];
        [_DB close];
    }
}
- (void)createTable{
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    
    [self.view addSubview:_table];
    
    _ID = [[NSMutableArray alloc]init];
    _Name = [[NSMutableArray alloc]init];
    
    [self reloadTable];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ID.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self openDataBase]) {
        [_DB executeUpdate:[NSString stringWithFormat:@"delete from People where id = %ld",[tableView cellForRowAtIndexPath:indexPath].tag]];
        [_DB executeUpdate:[NSString stringWithFormat:@"delete from Phone where iddd = %ld",[tableView cellForRowAtIndexPath:indexPath].tag]];
        
        [self reloadTable];
        
        [_DB close];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _Name[indexPath.row];
    cell.tag = [_ID[indexPath.row] integerValue];
    return cell;
}
- (void)viewWillAppear:(BOOL)animated{
    [self reloadTable];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
