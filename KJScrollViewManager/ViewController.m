//
//  ViewController.m
//  KJScrollViewManager
//
//  Created by JOIN iOS on 2018/8/7.
//  Copyright © 2018年 Kegem. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "MultipleGestureTableView.h"
/**管理器*/
#import "MultipleScrollViewManager.h"
/**下拉放大管理器*/
#import "HFStretchableTableHeaderView.h"
/**分页管理器*/
#import <SGPagingView.h>
/**子控制器*/
#import "KjChildViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>
/**管理器对象 这个在主控制器里进行声明*/
@property (strong, nonatomic) MultipleScrollViewManager *kjManager;
/**uitableView 用MultipleGestureTableView是为了多手势支持，也可以不用*/
@property (strong, nonatomic) MultipleGestureTableView *tView;
/**sectionHeaderView 用于放置UIPageViewController和分段管理器(就是子控制器顶部的按钮等)*/
@property (strong, nonatomic) UIView *kjView;
/**放置分段管理器(子控制器顶部的按钮等控件)*/
@property (strong, nonatomic) SGPageTitleView *kjTitleView;
/**分页控制器*/
@property (strong, nonatomic) SGPageContentScrollView *kjPageView;
/**放置所有的子控制器，用于在用户使用中途传值*/
@property (strong, nonatomic) NSArray *childArray;
/**TableHeaderView*/
@property (strong, nonatomic) UIView *kjHeaderView;
/**下拉放大的管理器*/
@property (strong, nonatomic) HFStretchableTableHeaderView *kjHfs;

@end

//得到屏幕height
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//得到屏幕width
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation ViewController

- (void)dealloc {
    /**需要销毁管理器的观察者*/
    if (self.kjManager) {
        [self.kjManager kjMultipleManagerDealloc];
    }
}

- (void)loadView {
    [super loadView];
    
    self.tView = [[MultipleGestureTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tView.delegate = self;
    self.tView.dataSource = self;
    [self.view addSubview:self.tView];
    [self.tView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //初始化多视图管理器
    self.kjManager = [MultipleScrollViewManager new];
    //把滚动视图交给管理器
    [self.kjManager addMainView:self.tView];
    
    //tableHeaderView 这个就是下拉放大的header
    self.kjHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.kjHeaderView.backgroundColor = [UIColor redColor];
    UIImageView *iV = [UIImageView new];
    iV.image = [UIImage imageNamed:@"demo_test"];
    iV.contentMode = UIViewContentModeScaleAspectFill;
    [self.kjHeaderView addSubview:iV];
    [iV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.kjHeaderView);
    }];
    [self.tView setTableHeaderView:self.kjHeaderView];
    //把header交给下拉放大管理器
    //下拉放大
    self.kjHfs = [HFStretchableTableHeaderView new];
    [self.kjHfs stretchHeaderForTableView:self.tView withView:self.kjHeaderView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**由于下拉放大必须实现，如果不需要下拉放大效果，这里可以不需要*/
- (void)viewDidLayoutSubviews {
    [self.kjHfs resizeView];
}

/**这里由于下拉放大需要，如果不需要下拉放大效果，则可以不实现*/
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.kjHfs scrollViewDidScroll:scrollView];
}

/**初始化sectionHeaderView*/
- (void)loadKjView {
    if (!self.kjView) {
        //由于是放到sectionHeader上的 所以这里需要使用frame,一般这里的宽高就是屏幕的宽高，如果要考虑导航栏和tabbar的高度，这里的高度是要减去导航栏高度(64或88)和tabar的高度
        self.kjView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        //创建子控制器
        [self loadChildVC];
        //初始化分页控制器
        [self loadPageView];
    }
}

/**初始化分页控制器(PageViewController)*/
- (void)loadPageView {
    //titleView
    if (!self.kjTitleView) {
        SGPageTitleViewConfigure *config = [SGPageTitleViewConfigure new];
        
        self.kjTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0)
                                                          delegate:self
                                                        titleNames:@[@"kjTitle0",@"kjTitle1",@"kjTitle2"]
                                                         configure:config];
        [self.kjView addSubview:self.kjTitleView];
    }
    //contentView
    if (!self.kjPageView) {
        
        self.kjPageView = [SGPageContentScrollView pageContentScrollViewWithFrame:CGRectMake(0, 44.0, SCREEN_WIDTH, SCREEN_HEIGHT-44)
                                                                         parentVC:self
                                                                         childVCs:self.childArray];
        self.kjPageView.delegatePageContentScrollView = self;
        [self.kjView addSubview:self.kjPageView];
        
        //因为分页管理器也是属于UIScrollView，也需要交给管理器来统一管理
        UIScrollView *sView = [self.kjPageView valueForKey:@"_scrollView"];
        [self.kjManager addMainRelevancyPageView:sView];
    }
    
    self.kjTitleView.selectedIndex = 0;
}

/**初始化子控制器*/
- (void)loadChildVC {
    KjChildViewController *kjvc_0 = [[KjChildViewController alloc] init];
    //这里可以进行首次传值，比如UIScrollView管理器对象 或者  其它的属性
    kjvc_0.sManager = self.kjManager;
    
    KjChildViewController *kjvc_1 = [[KjChildViewController alloc] init];
    //这里可以进行首次传值，比如UIScrollView管理器对象 或者  其它的属性
    kjvc_1.sManager = self.kjManager;
    
    KjChildViewController *kjvc_2 = [[KjChildViewController alloc] init];
    //这里可以进行首次传值，比如UIScrollView管理器对象 或者  其它的属性
    kjvc_2.sManager = self.kjManager;
    
    //可以有很多个子控制器 因为是demo 没有创建不同的控制器类 实际项目根据页面展示不同有多个控制器类
    
    //把子控制器都放入到数组，便于后续有什么需要传值的需求
    self.childArray = @[kjvc_0, kjvc_1, kjvc_2];
}


#pragma mark - UITableViewDelegate、UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //这个header的高度就是放置xjView的，所以一般都是当前页面的高度，如果考虑导航栏和tabbar。那么要减去导航栏高度和tabbar的高度
    return SCREEN_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.kjView) {
        [self loadKjView];
    }
    return self.kjView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - SGPageTitleViewDelegate
/**
 *  联动 pageContent 的方法
 *
 *  @param pageTitleView      SGPageTitleView
 *  @param selectedIndex      选中按钮的下标
 */
- (void)pageTitleView:(SGPageTitleView *)pageTitleView
        selectedIndex:(NSInteger)selectedIndex {
    [self.kjPageView setPageContentScrollViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentScrollViewDelegate
/**
 *  联动 SGPageTitleView 的方法
 *
 *  @param pageContentScrollView      SGPageContentScrollView
 *  @param progress                   SGPageContentScrollView 内部视图滚动时的偏移量
 *  @param originalIndex              原始视图所在下标
 *  @param targetIndex                目标视图所在下标
 */
- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView
                     progress:(CGFloat)progress
                originalIndex:(NSInteger)originalIndex
                  targetIndex:(NSInteger)targetIndex {
    [self.kjTitleView setPageTitleViewWithProgress:progress
                                     originalIndex:originalIndex
                                       targetIndex:targetIndex];
}

@end
