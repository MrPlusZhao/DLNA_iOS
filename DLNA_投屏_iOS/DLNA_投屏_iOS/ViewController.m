//
//  ViewController.m
//  DLNA_投屏_iOS
//
//  Created by zhaotianpeng on 2020/10/26.
//

#import "ViewController.h"
#import "MRDLNA.h"
#import <Photos/Photos.h>
#import "SearchDeviceViewController.h"

@interface ViewController ()<DLNADelegate>{
    NSInteger _index;
}
@property (nonatomic,strong)NSArray  *videosUrlArr;
@property (nonatomic,strong)MRDLNA  *dlnaManager;
@end

@implementation ViewController

-(NSArray*)videosUrlArr{
    if(_videosUrlArr==nil){
        _videosUrlArr = @[
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                        @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
                        ];
    }
    return _videosUrlArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"投屏视频播放";
   
   
}
- (void)prepareToPlayVideo
{
    self.dlnaManager = [MRDLNA sharedMRDLNAManager];
    self.dlnaManager.delegate = self;
    self.dlnaManager.typeStr = @"2";
    self.dlnaManager.playUrl = self.videosUrlArr.firstObject;
    [self.dlnaManager startDLNA];
    [self.dlnaManager dlnaGetVolume];
}
- (IBAction)upVideo:(id)sender {
    NSLog(@"upVideo");
    _index--;
    if(_index<0){
        _index = self.videosUrlArr.count-1;
    }
    [self.dlnaManager playTheURL:self.videosUrlArr[_index]];
}

- (IBAction)nextVideo:(id)sender {
    NSLog(@"nextVideo");
    _index++;
    if(_index>=self.videosUrlArr.count)  _index= 0;
    [self.dlnaManager playTheURL:self.videosUrlArr[_index]];
}
- (IBAction)volumeDown:(id)sender {
    NSLog(@"volumeDown");
    [self.dlnaManager volumeJumpValue:-5];
}
- (IBAction)volumeUp:(id)sender {
    NSLog(@"volumeUp");
    [self.dlnaManager volumeJumpValue:5];
}
- (IBAction)play:(id)sender {
    NSLog(@"play");
    [self.dlnaManager dlnaPlay];
}
- (IBAction)pause:(id)sender {
    NSLog(@"pause");
    [self.dlnaManager dlnaPause];
}
- (IBAction)quickBack:(id)sender {
    NSLog(@"quickBack");
    [self.dlnaManager dlnaPlay];
    [self.dlnaManager dlnaJump:-5.0];
}
- (IBAction)quickGo:(id)sender {
    NSLog(@"quickGo");
    [self.dlnaManager dlnaPlay];
    [self.dlnaManager dlnaJump:5.0];
}
- (IBAction)searchDevices:(id)sender {
    
    SearchDeviceViewController *SearchVC = [[SearchDeviceViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:SearchVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    [SearchVC setConnectedDevice:^{
        [self prepareToPlayVideo];
    }];
}



-(void)dealloc{
    [self.dlnaManager endDLNA];
    [MRDLNA destory];
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark DLNADelegate


-(void)dlnaStartPlay{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         NSLog(@"时长：%f", [self getVideoTotalTime:self.dlnaManager.playUrl]);
    });
}
-(float)getVideoTotalTime:(NSString*)urlStr{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:urlStr]];
    CMTime   time = [asset duration];
    return  ceil(time.value/time.timescale);
}
- (IBAction)sliderAction:(UISlider*)sender {
    NSLog(@"%.2f",sender.value);
    
}
@end
