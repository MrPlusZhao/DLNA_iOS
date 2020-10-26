//
//  SearchDeviceViewController.h
//  DLNA_投屏_iOS
//
//  Created by zhaotianpeng on 2020/10/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchDeviceViewController : UIViewController
@property (nonatomic, copy) void(^connectedDevice)(void);
@end

NS_ASSUME_NONNULL_END
