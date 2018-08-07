//
//  ViewController.m
//  test
//
//  Created by ghwang on 2018/5/21.
//  Copyright © 2018年 ghwang. All rights reserved.
//

#import "ViewController.h"
#import "SMScrollView.h"
#import "UIScrollView+Event.h"

#define W 38
#define H 40
#define ScreenW UIScreen.mainScreen.bounds.size.width
#define ScreenH UIScreen.mainScreen.bounds.size.height


@interface ViewController ()<UIScrollViewDelegate>{
    
    UIImage *image;
    NSArray *rowOnes,*rowTwos;
    float changeScal;
    float changeW;
    NSMutableArray *resultArr;
    NSDictionary *_curDic;
}
@property (nonatomic,strong)SMScrollView *myScrollView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //json
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"point" ofType:@"json"];
    NSData *jsondata = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"point======%@",dic);
    NSArray *areas = dic[@"areas"];
    
    NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    resultArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSDictionary *dic in areas) {
        
        NSMutableArray *pointx = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *pointy = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *points = dic[@"area"];
        NSString *areaName = dic[@"name"];
        
        for (NSDictionary *pdic in points) {
            
            [pointx addObject:pdic[@"x"]];
            [pointy addObject:pdic[@"y"]];
        }
        NSArray *xresult = [pointx sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [obj1 compare:obj2];
        }];
        
        NSArray *yresult = [pointy sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            return [obj1 compare:obj2];
        }];
        
        [resultDic setObject:areaName forKey:@"name"];
        [resultArr addObject:@{@"name":areaName,@"minx":xresult[0],@"maxx":xresult[3],
                               @"miny":yresult[0],@"maxy":yresult[3]}];
        
    }
    //计算出图片的像素宽像素高，按照比例再决定显示图片空间的宽高
    image = [UIImage imageNamed:@"seat"];
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    CGFloat fixelH = CGImageGetHeight(image.CGImage);
    int height = ScreenW/(fixelW/fixelH);
    changeScal = 1;
    UIImageView *bgImgView = [UIImageView new];
    bgImgView.userInteractionEnabled = YES;
    bgImgView.frame =  CGRectMake(0, 0, self.view.frame.size.width*changeScal, height*changeScal);
    bgImgView.image = image;
    [self.view addSubview:bgImgView];
    
    //支持缩放控件
    self.myScrollView = [[SMScrollView alloc] initWithFrame:CGRectMake(0, 130, self.view.frame.size.width, ScreenH-130)];
    self.myScrollView.userInteractionEnabled = YES;
    self.myScrollView.maximumZoomScale = 3;
    self.myScrollView.delegate = self;
    self.myScrollView.centerZoomingView = NO;
    self.myScrollView.contentSize = CGSizeMake(ScreenW, ScreenH);
    self.myScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myScrollView.alwaysBounceVertical = YES;
    self.myScrollView.alwaysBounceHorizontal = YES;
    self.myScrollView.stickToBounds = NO;
    [self.myScrollView addViewForZooming:bgImgView];
    [self.view addSubview:self.myScrollView];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return self.myScrollView.viewForZooming;
}


//当有一个或多个手指触摸事件在当前视图或window窗体中响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    int x = point.x;
    int y = point.y;
    NSLog(@"touch (x, y) is (%d, %d)", x, y);
    
    
    //根据比例算出点击的点对应的图片分辨率
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    float piexScale = (fixelW/ScreenW);
    float realX = x*piexScale;
    float realY = y*piexScale;
    NSLog(@"Scale(x, y) is (%f, %f)", realX,realY);
    
    for (NSDictionary *dic in resultArr) {
        
        int minx = [dic[@"minx"] intValue];
        int maxx = [dic[@"maxx"] intValue];
        int miny = [dic[@"miny"] intValue];
        int maxy = [dic[@"maxy"] intValue];
        
        if ((realX>minx && realX<maxx) && (realY > miny && realY < maxy)) {
            
            _curDic = dic;
            break;
        }
    }
    
    if (_curDic) {
        
        UIAlertController *controll = [UIAlertController alertControllerWithTitle:@"" message:_curDic[@"name"] preferredStyle:UIAlertControllerStyleAlert];
        [controll addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:controll animated:YES completion:^{
            
        }];

    }
    _curDic = nil;
}

@end
