                                //
//  RootController.m
//  天气预报
//
//  Created by Mr_Guo on 16/6/14.
//  Copyright © 2016年 Mr_Guo. All rights reserved.
//

#import "RootController.h"
#import "Weather_data.h"
#import <CoreLocation/CoreLocation.h>
#import "NSArray+info.h"
#import <UIImageView+AFNetworking.h>
#import "Waether.h"
#import "SVProgressHUD.h"
#import "Index.h"
#import "WCell.h"
#import "ZCell.h"
#import <MJRefresh.h>

#define MAS_SHORTHAND

#define MAS_SHORTHAND_GLOBALS

//导入框架
#import "Masonry.h"

@interface RootController () <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)IBOutlet UILabel *city;
@property (nonatomic, weak) IBOutlet UIImageView *weatherImage;
@property (nonatomic, weak) IBOutlet UILabel *weather;
@property (nonatomic, weak) IBOutlet UILabel *sheshi;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nullable, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *cityLoca;
@property (weak, nonatomic) IBOutlet UITextField *text;
@property (weak, nonatomic) IBOutlet UIButton *search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *placemarks;
@property (strong, nonatomic) Waether *w;
@property (weak, nonatomic) IBOutlet UITableView *zTableView;
@property (weak, nonatomic) IBOutlet UITableView *wTableView;
@property (weak, nonatomic) IBOutlet UILabel *pm;

@end

@implementation RootController

/**
 重写当前位置的set方法，在给它赋值的时候重新请求数据
 */
-(void)setPlacemarks:(NSArray *)placemarks {

    _placemarks = placemarks;
    [self.tableView reloadData];

}

//重写当前城市的set方法，在当前城市改变的时候将城市存储到偏好设置中，并给界面的当前位置赋值
-(void)setCityLoca:(NSString *)cityLoca {
    
    _cityLoca = cityLoca;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:cityLoca forKey:@"city"];
    self.city.text = cityLoca;
}

//重写当前城市天气的set方法，在当前城市天气改变的时候刷新指数table和未来天气table
-(void)setW:(Waether *)w {
 
    _w = w;
    [self.wTableView reloadData];
    [self.zTableView reloadData];
}

//搜索输入的城市
- (IBAction)didClickSearch:(id)sender {
    
    self.tableView.hidden = NO;
    //自动收回键盘
    [self.view endEditing:YES];
    
    CLGeocoder *geocoder = [CLGeocoder new];
    
    //2. 实现地理编码方法
    [geocoder geocodeAddressString:self.text.text completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        //placemarks : 地标数组 --> 主要的是CLLocation / 城市属性
        
        //3.1 遍历数组
        if (placemarks.count == 0 || error) {
            NSLog(@"解析有问题");
            return ;
        }
        
        self.placemarks = placemarks;
        // 注意: 地理编码 可能出现重名的问题, 所以将来如果对标对象大于1, 应该给用户一个列表选择

        [SVProgressHUD showWithStatus:@"正在搜索" maskType:SVProgressHUDMaskTypeBlack];
        
        //模拟延时，提高用户体验
        
        if (self.placemarks.count > 0)
            [UIView animateWithDuration:0.25 animations:^{
                //将搜索结果列表table显示
                [SVProgressHUD dismiss];
                self.tableView.hidden = NO;
            }];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];

    //读取当前位置的经纬度和城市
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *la = [ud objectForKey:@"latitude"];
    NSString *lo = [ud objectForKey:@"longitude"];
    self.cityLoca = [ud objectForKey:@"city"];

    //如果读取到存储的经纬度，则用这个经纬度请求数据，否则自动定位
    if (la != 0 && lo != 0) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[la floatValue] longitude:[lo floatValue]];
        [self loadWeatherWith:location];
    } else {
        [self didClickLocation];
    }
    
    //设置搜索城市列表的结果列表的数据源和代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //设置指数列表和未来天气列表的数据源
    self.zTableView.dataSource = self;
    self.wTableView.dataSource = self;
    
    //设置指数表格的cell的高度
    self.zTableView.rowHeight = 100;
    
    //设置取消指数表格和未来天气表格的弹簧效果与取消滚动条
    self.wTableView.bounces = NO;
    self.wTableView.showsVerticalScrollIndicator = NO;
    self.zTableView.bounces = NO;
    self.zTableView.showsVerticalScrollIndicator = NO;
    
    //取消指数表格和未来天气表格的可选中效果
    self.wTableView.allowsSelection = NO;
    self.zTableView.allowsSelection = NO;
    [self creatViews];
    
}


//请求天气数据方法
- (void) loadWeatherWith:(CLLocation *)loca {

    [SVProgressHUD showWithStatus:@"正在获取天气" maskType:SVProgressHUDMaskTypeBlack];
  
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *la = [ud objectForKey:@"latitude"];
        NSString *lo = [ud objectForKey:@"longitude"];
        self.cityLoca = [ud objectForKey:@"city"];
        loca = [[CLLocation alloc] initWithLatitude:[la floatValue] longitude:[lo floatValue]];
    
    [Waether loadWeatherWithCity:(CLLocation *)loca WithSuccessBlock:^(Waether *w) {
        [self reloadUI:w];
        self.w = w;
        [SVProgressHUD dismiss];
      //  self.cityLoca = w.currentCity;
    } andErrorBlock:^(NSError *error){
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"天气获取出错" maskType:SVProgressHUDMaskTypeBlack];
    }];
}

//在请求数据结束天气数据通过代码块将数据传过来以后刷新界面数据
- (void) reloadUI:(Waether *)w {

    //取出今天的天气数据
    Weather_data *wd = [w.weather_datas firstObject];

    //填充温度数据
    self.sheshi.text = [NSString stringWithFormat:@"%@", wd.temperature];
    //填充天气数据
    self.weather.text = wd.weather;
    //设置天气对应图片
    self.weatherImage.image = [UIImage imageNamed:[self loadWeatherImageNamed:wd.weather]];
    //设置当前时间
    self.time.text = wd.date;
    //设置pm2.5指数
    self.pm.text = [NSString stringWithFormat:@"%@", w.pm25];
    
    
    //根据pm2.5指数显示不同的颜色
    if ([w.pm25 intValue] <= 50) {
        self.pm.backgroundColor = [UIColor greenColor];
        self.pm.textColor = [UIColor blackColor];
    }
    if ([w.pm25 intValue] > 50 && [w.pm25 intValue] <=100) {
        self.pm.backgroundColor = [UIColor yellowColor];
        self.pm.textColor = [UIColor blackColor];
    }
    if ([w.pm25 intValue] > 100 && [w.pm25 intValue] <=150) {
        self.pm.backgroundColor = [UIColor orangeColor];
        self.pm.textColor = [UIColor whiteColor];
    }
    if ([w.pm25 intValue] > 150 && [w.pm25 intValue] <=200) {
        self.pm.backgroundColor = [UIColor redColor];
        self.pm.textColor = [UIColor whiteColor];
    }
    if ([w.pm25 intValue] > 200 && [w.pm25 intValue] <=300) {
        self.pm.backgroundColor = [UIColor purpleColor];
        self.pm.textColor = [UIColor whiteColor];
    }
    if ([w.pm25 intValue] > 300) {
        self.pm.backgroundColor = [UIColor brownColor];
        self.pm.textColor = [UIColor whiteColor];
    }
}

//点击定位
- (void) didClickLocation {
    
    [SVProgressHUD showWithStatus:@"正在定位" maskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [SVProgressHUD dismiss];
            
            self.mgr = [CLLocationManager new];
            
            if ([self.mgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.mgr requestWhenInUseAuthorization];
            }
            
            self.mgr.delegate = self;
            
            [self.mgr startUpdatingLocation];
        
    });
}

//设置导航栏标题与按钮
- (void) creatViews {
    
    self.navigationItem.title = @"天气预报";
    UIImage *img = [UIImage imageNamed:@"loca"];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(didClickLocation)];
    self.navigationItem.leftBarButtonItem = btn;
    
    
    //读取当前位置的经纬度和城市
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(loadWeatherWith:)];
    self.navigationItem.rightBarButtonItem = rightBtn;

  }


//根据天气情况返回对应的天气图片名
- (NSString *)loadWeatherImageNamed:(NSString *)type {

    if ([type isEqualToString:@"晴"]) {
        return @"8.png";
    }
    if ([type isEqualToString:@"阴"]) {
        return @"5.png";
    }
    if ([type isEqualToString:@"多云"]) {
        return @"11.png";
    }
    if([type isEqualToString:@"雨"])
    {
        return @"15.png";
    }
    if([type isEqualToString:@"雪"])
    {
        return @"10.png";
    }
    if([type isEqualToString:@"大雨转晴"])
    {
        return @"4.png";
    }
    if([type isEqualToString:@"阴转晴"])
    {
        return @"12.png";
    }
    if([type isEqualToString:@"雨加雪"])
    {
        return @"13.png";
    }
    if([type isEqualToString:@"阵雨"])
    {
        return @"15.png";
    }
    if([type isEqualToString:@"雷阵雨"])
    {
        return @"7.png";
    }
    if ([type isEqualToString:@"中雨"]) {
        return @"15.png";
    }
    if ([type isEqualToString:@"小雪"]) {
        return @"10.png";
    }
    if([type isEqualToString:@"小雨"])
    {
        return @"15.png";
    }
    if([type isEqualToString:@"中雪"])
    {
        return @"14.png";
    }
    if([type isEqualToString:@"大雨"])
    {
        return @"3.png";
    }
    if([type isEqualToString:@"大雪"])
    {
        return @"2.png";
    }
    if ([type isEqualToString:@"雷阵雨转多云"]) {
        return @"7.png";
    }
    if ([type isEqualToString:@"阴转多云"]) {
        return @"5.png";
    }
    if ([type rangeOfString:@"晴"].location != NSNotFound) {
        return @"8.png";
    }
    if ([type rangeOfString:@"阴"].location != NSNotFound) {
        return @"5.png";
    }
    if ([type rangeOfString:@"多云"].location != NSNotFound) {
        return @"11.png";
    }
    if([type rangeOfString:@"雨"].location != NSNotFound)
    {
        return @"15.png";
    }
    if([type rangeOfString:@"雪"].location != NSNotFound)
    {
        return @"10.png";
    }
    return @"9";
}

//定位代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    CLLocation *location = locations.lastObject;
    
    [self loadWeatherWith:location];
    
    //反地理编码
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       //放错处理
        if (placemarks.count == 0 || error) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"定位出错" maskType:SVProgressHUDMaskTypeBlack];
            return;
        }
        
        for (CLPlacemark *placemark in placemarks) {
            
            //将当前位置赋给控制器属性
            self.cityLoca = [NSString stringWithFormat:@"%@%@", placemark.locality, placemark.subLocality];
            
            //根据当前位置请求天气数据
            [self loadWeatherWith:placemark.location];
            
            //将当前位置和城市存储到偏好设置中
            NSString *la = [NSString stringWithFormat:@"%lf", placemark.location.coordinate.latitude];
            NSString *lo = [NSString stringWithFormat:@"%lf", placemark.location.coordinate.longitude];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:la forKey:@"latitude"];
            [ud setObject:lo forKey:@"longitude"];
            NSString *ci = [NSString stringWithFormat:@"定位完成\n当前位置：%@", self.cityLoca];
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:ci];
        }
        
    }];
    
    [self.mgr stopUpdatingLocation];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tag == 10) {
        return self.placemarks.count;
    }
    if (tableView.tag == 20) {
        return self.w.indexs.count;
    }
    if (tableView.tag == 30) {
        return self.w.weather_datas.count - 1;
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView.tag == 10) {
        CLPlacemark *placemark = self.placemarks[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"citycell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"citycell"];
        }
        cell.textLabel.text = placemark.name;
        return cell;
    } else if (tableView.tag == 20) {
        Index *idx = self.w.indexs[indexPath.row];
        ZCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zcell"];
        if (cell == nil) {
            cell = [[ZCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zcell"];
        }
        cell.idx = idx;
        return cell;
    } else if (tableView.tag == 30) {
        Weather_data *wd = self.w.weather_datas[indexPath.row + 1];
        WCell *cell = (WCell *)[tableView dequeueReusableCellWithIdentifier:@"wcell"];
        if (cell == nil) {
            cell = [[WCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wcell"];
        }
        cell.wd = wd;
        return cell;
    }
    return nil;
}

//城市搜索结果列表点击自动切换位置并根据当前城市确定经纬度请求天气数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.tableView.hidden = YES;
    
    [SVProgressHUD showWithStatus:@"正在切换" maskType:SVProgressHUDMaskTypeBlack];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.hidden = YES;
    }];
  
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CLPlacemark *placemark = self.placemarks[indexPath.row];
        
        NSString *la = [NSString stringWithFormat:@"%lf", placemark.location.coordinate.latitude];
        NSString *lo = [NSString stringWithFormat:@"%lf", placemark.location.coordinate.longitude];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:la forKey:@"latitude"];
        [ud setObject:lo forKey:@"longitude"];
        
        NSString *str = [NSString stringWithFormat:@"切换成功!\n当前位置:%@", placemark.name];

        self.cityLoca = [NSString stringWithFormat:@"%@",placemark.name];
        
        [self loadWeatherWith:placemark.location];
        [SVProgressHUD dismiss];
        self.placemarks = nil;
        [SVProgressHUD showSuccessWithStatus:str];
  
    });
}

@end
