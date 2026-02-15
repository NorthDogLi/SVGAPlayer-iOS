//
//  ViewController.m
//  SVGAPlayer
//
//  Created by 崔明辉 on 16/6/17.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import "ViewController.h"
#import "SVGA.h"

@interface ViewController ()<SVGAPlayerDelegate>
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (weak, nonatomic) IBOutlet UISlider *aSlider;
@property (weak, nonatomic) IBOutlet UIButton *onBeginButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _svgaPlayer = [[SVGAPlayer alloc] init];
    _svgaPlayer.delegate = self;
    _svgaPlayer.loops = 1; // 只执行一次
    // @"Forward" 或者 @"Backward"
    //_svgaPlayer.fillMode = @"Forward";
    _svgaPlayer.clearsAfterStop = NO; //执行完毕是否删除清空，内部默认YES
    //_svgaPlayer.contentMode = UIViewContentModeScaleAspectFill;
    _svgaPlayer.contentMode = UIViewContentModeScaleAspectFit;
    
    _parser = [[SVGAParser alloc] init];
    
    [self onChange:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self onBeginButton:self.onBeginButton];
}

- (void)startSvgaWithData:(NSData *)data cacheKey:(NSString *)cacheKey {
    CGFloat sizeInMB = data.length / (1024.0f * 1024.0f);
    
    NSLog(@"svga - 下载后的大小是：%zd 字节，约为:%0.2fM", data.length, sizeInMB);
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

- (IBAction)onChange:(id)sender {
    NSArray *items = @[
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/EmptyState.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/HamburgerArrow.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/PinJump.svga?raw=true",
                       @"https://github.com/svga/SVGA-Samples/raw/master/Rocket.svga",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/TwitterHeart.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/Walkthrough.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/angel.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/halloween.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/kingset.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/posche.svga?raw=true",
                       @"https://cdn.jsdelivr.net/gh/svga/SVGA-Samples@master/rose.svga?raw=true",
                       ];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    parser.enabledMemoryCache = YES;
    [self.parser parseWithURL:[NSURL URLWithString:items[arc4random() % items.count]]
         completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             if (videoItem != nil) {
                 self.svgaPlayer.videoItem = videoItem;
                 NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
                 [para setLineBreakMode:NSLineBreakByTruncatingTail];
                 [para setAlignment:NSTextAlignmentCenter];
                 NSAttributedString *str = [[NSAttributedString alloc]
                                            initWithString:@"Hello, World! Hello, World!"
                                            attributes:@{
                                                NSFontAttributeName: [UIFont systemFontOfSize:28],
                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                NSParagraphStyleAttributeName: para,
                                            }];
                 [self.svgaPlayer setAttributedText:str forKey:@"banner"];
                 [self.svgaPlayer startAnimation];
                 
//                 [self.aPlayer startAnimationWithRange:NSMakeRange(10, 25) reverse:YES];
             }
         } failureBlock:nil];
//
//        [parser parseWithURL:[NSURL URLWithString:@"https://github.com/svga/SVGA-Samples/raw/master_aep/BitmapColorArea1.svga"] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
//            if (videoItem != nil) {
//                self.aPlayer.videoItem = videoItem;
//                [self.aPlayer setImageWithURL:[NSURL URLWithString: @"https://i.imgur.com/vd4GuUh.png"] forKey:@"matte_EEKdlEml.matte"];
//                [self.aPlayer startAnimation];
//            }
//        } failureBlock:nil];
    
//    [parser parseWithNamed:@"Rocket" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//        self.aPlayer.videoItem = videoItem;
//        [self.aPlayer startAnimation];
//    } failureBlock:nil];
}

- (IBAction)onSliderClick:(UISlider *)sender {
    [self.svgaPlayer stepToPercentage:sender.value andPlay:NO];
}

- (IBAction)onSlide:(UISlider *)sender {
    [self.svgaPlayer stepToPercentage:sender.value andPlay:NO];
}

- (IBAction)onChangeColor:(UIButton *)sender {
    self.view.backgroundColor = sender.backgroundColor;
}

- (IBAction)onBeginButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.selected) {
        [self.svgaPlayer pauseAnimation];
    } else {
        [self.svgaPlayer stepToPercentage:(self.aSlider.value == 1 ? 0 : self.aSlider.value) andPlay:YES];
    }
}

- (IBAction)onRetreatButton:(UIButton *)sender {
    
}

- (IBAction)onForwardButton:(UIButton *)sender {
    
}


#pragma - mark SVGAPlayer Delegate
- (void)svgaPlayerDidAnimatedToPercentage:(CGFloat)percentage {
    self.aSlider.value = percentage;
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player {
    self.onBeginButton.selected = YES;
}

@end
