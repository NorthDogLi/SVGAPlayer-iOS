//
//  TestVC1.m
//  SVGAPlayer
//
//  Created by huajiao on 2026/2/15.
//  Copyright © 2026 UED Center. All rights reserved.
//

#import "TestVC1.h"
#import "TestVC2.h"

@interface TestVC1 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *items;


@end

@implementation TestVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TestVC1";
    self.view.backgroundColor = UIColor.whiteColor;
    self.items = @[@"TestVC2"];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *textStr = self.items[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.backgroundColor = UIColor.clearColor;
    cell.contentView.backgroundColor = UIColor.clearColor;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = UIColor.blueColor;
    cell.textLabel.text = textStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        TestVC2 *subVC = [[TestVC2 alloc] init];
        [self.navigationController pushViewController:subVC animated:YES];
        
    } else if (indexPath.row == 1) {
        
    } else {
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 34;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//        [_tableView kc_registerClass:UITableViewCell.class];
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 34;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

@end
