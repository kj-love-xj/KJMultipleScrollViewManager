//
//  KjChildViewController.m
//  KJScrollViewManager
//
//  Created by JOIN iOS on 2018/8/7.
//  Copyright © 2018年 Kegem. All rights reserved.
//

#import "KjChildViewController.h"
#import <Masonry.h>

@interface KjChildViewController ()<UITableViewDelegate, UITableViewDataSource>

/**一切可以滑动的view*/
@property (strong, nonatomic) UITableView *tView;

@end

@implementation KjChildViewController

- (void)loadView {
    [super loadView];
    self.tView  = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    [self.view addSubview:self.tView];
    [self.tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tView registerClass:UITableViewCell.class forCellReuseIdentifier:@"kjcell"];
    //把滚动视图交给管理器
    if (self.sManager) {
        [self.sManager addChildView:self.tView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kjcell"];
    cell.textLabel.text = [NSString stringWithFormat:@"row = %ld",(long)indexPath.row];
    return cell;
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
