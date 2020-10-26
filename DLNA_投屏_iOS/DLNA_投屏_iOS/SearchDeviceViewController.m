//
//  SearchDeviceViewController.m
//  DLNA_投屏_iOS
//
//  Created by zhaotianpeng on 2020/10/26.
//

#import "SearchDeviceViewController.h"
#import "MRDLNA.h"

@interface SearchDeviceViewController ()<UITableViewDelegate,UITableViewDataSource,DLNADelegate>
@property (nonatomic,strong)UIActivityIndicatorView *activityView;
@property (nonatomic,strong)UITableView  *baseV;
@property (nonatomic,strong)NSArray  *devicesArr;
@property (nonatomic,strong)MRDLNA  *dlnaManager;
@end

@implementation SearchDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索设备";
    [self setUpUI];
    [self makeActivityView];
    [self makeRightBtn];
    [self makeLeftBtn];
    [self makeDlnaManager];
    [self refresh];
}

-(void)makeDlnaManager{
    self.dlnaManager = [MRDLNA sharedMRDLNAManager];
    self.dlnaManager.delegate  = self;
}

-(NSArray*)devicesArr{
    if(_devicesArr==nil){
        _devicesArr = [NSArray  array];
    }
    return _devicesArr;
}
-(void)setUpUI{
    self.baseV = [UITableView new];
    self.baseV.frame = self.view.bounds;
    [self.view addSubview:self.baseV];
    self.baseV.delegate =self;
    self.baseV.dataSource = self;
    self.baseV.tableFooterView = [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.devicesArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchDevicesVC"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchDevicesVC"];
    }
    CLUPnPDevice *device = self.devicesArr[indexPath.row];
    cell.textLabel.text = device.friendlyName;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.dlnaManager.device =  self.devicesArr[indexPath.row];
    if (self.connectedDevice) {
        self.connectedDevice();
    }
    NSLog(@"连接设备");
    
}

-(void)makeRightBtn{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 100, 60);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"重新搜索" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)makeLeftBtn{
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 100, 60);
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}
- (void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)makeActivityView{
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityView setColor:[UIColor lightGrayColor]];
    self.activityView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 200);
}

-(void)refresh{
    self.devicesArr = nil;
    [self.baseV reloadData];
    [self.dlnaManager startSearch];
    [self.view addSubview:self.activityView];
    [self.activityView startAnimating];
}

-(void)searchDLNAResult:(NSArray *)devicesArray{
    self.devicesArr = devicesArray;
}

-(void)dlnaDidEndSearch{
    [self.baseV reloadData];
    [self.activityView removeFromSuperview];
    if (self.devicesArr.count == 0) {
        NSLog(@"没有搜索到设备");
    }
}

@end
