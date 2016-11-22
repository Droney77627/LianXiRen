//
//  addViewController.m
//  tongxunluFMDB
//
//  Created by mac on 17/11/19.
//  Copyright (c) 2017年 mac. All rights reserved.
//

#import "addViewController.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface addViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    FMDatabase *_DB;
}
@property (nonatomic,retain) UITextField *nameText;
@property (nonatomic,retain) UITextField *numText;
@property (nonatomic,retain) UITableView *table;
@property (nonatomic,retain) NSMutableArray *num;
@end

@implementation addViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameText = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, WIDTH-200, 40)];
    _nameText.text = _name;
    _nameText.backgroundColor = [UIColor whiteColor];
    _nameText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_nameText];
    
    _numText = [[UITextField alloc]initWithFrame:CGRectMake(100, 180, WIDTH-200, 40)];
    _numText.backgroundColor = [UIColor whiteColor];
    _numText.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_numText];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 260, WIDTH-200, 40)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:@"add" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 340, WIDTH, HEIGHT-340) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    _num = [[NSMutableArray alloc]init];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [self reloadTable];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _num.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSLog(@"%@",_num);
    NSLog(@"1");
    cell.textLabel.text = [NSString stringWithFormat:@"%@",_num[indexPath.row]];
    NSLog(@"2");
    return cell;
}
- (void)btnClick{
    if ([self openDataBase]) {
        NSLog(@"open over");
        if (_ID == -1) {
        
            [_DB executeUpdate:[NSString stringWithFormat:@"insert into People (name) values ('%@')",_nameText.text]];
            FMResultSet *set =[_DB executeQuery:@"select * from People"];
            int ID = 1;
            while ([set next]){
                ID = [set intForColumnIndex:0];
            }
            _ID = ID;
            NSLog(@"%d",_ID);
            
        }
        NSLog(@"%d,%@",_ID,_numText.text);
        [_DB executeUpdate:[NSString stringWithFormat:@"insert into Phone (iddd,number) values (%d,%@)",_ID,_numText.text]];
        [self reloadTable];
        _numText.text = nil;
        [_DB close];
    }
    
    
}- (void)reloadTable{
    if ([self openDataBase]) {
        NSMutableArray *Num = [[NSMutableArray alloc]init];
        FMResultSet *set = [_DB executeQuery:[NSString stringWithFormat:@"select * from Phone where iddd = %d",_ID]];
        while ([set next]) {
            [Num addObject:@([set intForColumnIndex:2])];
            NSLog(@"%@",Num);
        }
        _num = Num;
        NSLog(@"%@",_num);
        [_table reloadData];
        [_DB close];
    }
}
- (BOOL)openDataBase{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"dataBase.sqlite"];
    if (!_DB) {
        _DB = [[FMDatabase alloc]initWithPath:filePath];
    }
    return [_DB open];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
