//
//  TestVC2.m
//  SVGAPlayer
//
//  Created by huajiao on 2026/2/15.
//  Copyright © 2026 UED Center. All rights reserved.
//

#import "TestVC2.h"
#import "SVGA.h"

@interface TestVC2 ()<SVGAPlayerDelegate>
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@end

@implementation TestVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TestVC2";
    self.view.backgroundColor = UIColor.whiteColor;
    
    _svgaPlayer = [[SVGAPlayer alloc] init];
    _svgaPlayer.delegate = self;
    _svgaPlayer.loops = INT_MAX; // 只执行一次
    // @"Forward" 或者 @"Backward"
    //_svgaPlayer.fillMode = @"Forward";
    _svgaPlayer.clearsAfterStop = NO; //执行完毕是否删除清空，内部默认YES
    //_svgaPlayer.contentMode = UIViewContentModeScaleAspectFill;
    _svgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.svgaPlayer];
    self.svgaPlayer.frame = self.view.bounds;
    
    _parser = [[SVGAParser alloc] init];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(40, 140, 60, 40);
    button.backgroundColor = UIColor.redColor;
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(startAni) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)startAni {
//    NSString *nameStr = @"hello";
    NSString *nameStr = @"resource-1771083597996842";
    NSString *filePath = [[NSBundle mainBundle] pathForResource:nameStr ofType:@"svga"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    [self startSvgaWithData:data cacheKey:nameStr];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    
}

- (void)startSvgaWithData:(NSData *)data cacheKey:(NSString *)cacheKey {
    CGFloat sizeInMB = data.length / (1024.0f * 1024.0f);
    
    NSLog(@"svga - 资源：[%@]数据的大小是：%zd 字节，约为:%0.2fM", cacheKey, data.length, sizeInMB);
    [self.parser parseWithData:data cacheKey:cacheKey completionBlock:^(SVGAVideoEntity *videoItem) {
        if (videoItem) {
            NSLog(@"svga - fps=%d, frame=%d，图片数量：%zd", videoItem.FPS, videoItem.frames, videoItem.images.count);
            self.svgaPlayer.videoItem = videoItem;
            [self startAninmation];
        } else {
            
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)startAninmation {
    
    [self.svgaPlayer startAnimation];
}

- (void)stopAnimation {
    [self.svgaPlayer stopAnimation];
}


@end
