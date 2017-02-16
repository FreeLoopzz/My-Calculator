//
//  ViewController.m
//  计算器-黄增
//
//  Created by 黄增 on 2017/2/15.
//  Copyright © 2017年 黄增. All rights reserved.
//

#import "ViewController.h"
#import "MyLabel.h"

#define ViewWidth self.view.frame.size.width
#define ViewHeight self.view.frame.size.height

@interface ViewController ()

@property (nonatomic,weak)UILabel *label;
@property(copy,nonatomic) NSMutableString *string;  //NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property(assign,nonatomic) double num1,num2;
@property(copy,nonatomic)NSString *str;
@property(copy,nonatomic)NSMutableString *string1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    //添加显示框
    [self addShowLable];
    
    //添加按钮
    [self addButton];
}


//懒加载初始化可变字符串
- (NSMutableString *)string{
    
    if (!_string) {
        _string = [[NSMutableString alloc] init];
    }
    return _string;
}


- (NSMutableString *)string1{
    
    if (!_string1) {
        _string1 = [[NSMutableString alloc] init];
    }
    return _string1;
}


- (void)addShowLable{
    
    MyLabel *label = [[MyLabel alloc] init];
    //背景颜色
    label.backgroundColor = [UIColor blackColor];
    //文字颜色
    label.textColor = [UIColor whiteColor];
    //文字
    label.text = @"0";
    //字体
    label.font = [UIFont systemFontOfSize:50];
    //文字居右边显示
    label.textAlignment = NSTextAlignmentRight;
    //文字居下边显示
    [label setVerticalAlignment:VerticalAlignmentBottom];
    //设置label的frame
    label.frame = CGRectMake(0, 0, ViewWidth, ViewHeight / 3);
    
    [self.view addSubview:label];
    
    self.label = label;
}


- (void)addButton{
    
    //把所有按钮标题加入数组
    NSArray *array = @[@"AC",@"delete",@"%",@"/",@"7",@"8",@"9",@"*",@"4",@"5",@"6",@"-",@"1",@"2",@"3",@"+",@"0",@".",@"="];
    
    //最大列数
    int maxColsCount = 4;
    
    //最大行数
    int maxLineCount = 5;
    
    //提取每个按钮宽度
    CGFloat buttonW = ViewWidth / maxColsCount;
    
    //提取每个按钮高度
    CGFloat buttonH = ViewHeight / 3 * 2 / maxLineCount;
    
    for (int i = 0; i < array.count; i++) {//连续创建按钮
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //为每个button绑定一个tag,为方便以后区分哪个按钮点击
        button.tag = i;
        //设置按钮标题
        [button setTitle:array[i] forState:UIControlStateNormal];
        //设置标题颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //为button添加事件
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ((i + 1) % 4 == 0 || i == 18) {//判断是否为第四列
            button.backgroundColor = [UIColor colorWithRed:255/255.0 green:190/255.0 blue:0/255.0 alpha:1];
        }else if (i == 0 || i == 1 || i == 2){//是否为前三个按钮
            button.backgroundColor = [UIColor grayColor];
        }else{
            button.backgroundColor = [UIColor colorWithRed:210/255.0 green:211/255.0 blue:214/255.0 alpha:1];
        }
        //设置按钮frame
        button.frame = CGRectMake(i == 18 ? (i % maxColsCount) * buttonW + buttonW : (i % maxColsCount) * buttonW, (i / maxColsCount) * buttonH + CGRectGetMaxY(self.label.frame),i == 17 ? buttonW * 2 - 1 : buttonW - 1, buttonH - 1);
        
        [self.view addSubview:button];
    }
    
    self.str = @"";
}


- (void)buttonClick:(UIButton *)button{
    
    if (button.tag == 4 || button.tag == 5 || button.tag == 6 || button.tag == 8 || button.tag == 9 || button.tag == 10 || button.tag == 12 || button.tag == 13 || button.tag == 14 || button.tag == 16 || button.tag == 17) {//如果是输入数字
        [self.string appendString:[button currentTitle]];      //数字连续输入
        self.label.text= self.string;//显示数值
        self.num1=[self.label.text doubleValue];               //保存输入的数值
        //如果点击了运算符
    }else if (button.tag == 18 || button.tag == 3 || button.tag == 7 || button.tag == 11 || button.tag == 15){
        NSLog(@"点击了%zd",button.tag);
        if ([self.str isEqualToString:@""])//当str里为空
        {
            self.num2=self.num1;
            self.label.text=[NSString stringWithString:_string];     //只要是符号就显示数值
            [self.string setString:@""];                             //字符串清零
            self.str=[button currentTitle];                          //保存运算符为了作判断作何种运算
            [self.string appendString:self.str];
            self.label.text=[NSString stringWithString:_string];     //显示数值
            [self.string setString:@""];          //字符串清零
        }
        else
        {
            //输出上次计算结果
            if ([self.str isEqualToString:@"+"])//之前的符号是+
            {
                [self.string setString:@""];//字符串清零
                self.num2+=self.num1;//num2是运算符号左边的数值，还是计算结果
                
                //输出上次结果后判断这次输入的是何符号
                if ([[button currentTitle]isEqualToString:@"="])
                {
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    self.str=@"";
                }
                else if ([[button currentTitle]isEqualToString:@"+"]||[[button currentTitle]isEqualToString:@"-"]||[[button currentTitle]isEqualToString:@"*"]||[[button currentTitle]isEqualToString:@"/"])
                {
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    [self.string setString:@""];   //字符串清零
                    self.str=[button currentTitle];//保存运算符为了作判断作何种运算
                    NSLog(@"%@",_str);
                    [self.string appendString:self.str];
                    [self.string setString:@""];//字符串清零
                }
            }
            
            else if ([self.str isEqualToString:@"-"])//之前的符号是-
            {
                [self.string setString:@""];//字符串清零
                self.num2-=self.num1;
                //输出上次结果后判断这次输入的是何符号
                if ([[button currentTitle]isEqualToString:@"="])
                {
                    NSLog(@"self.num2  is  %f",self.num2);
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    self.str=@"";
                }
                else if ([[button currentTitle]isEqualToString:@"+"]||[[button currentTitle]isEqualToString:@"-"]||[[button currentTitle]isEqualToString:@"*"]||[[button currentTitle]isEqualToString:@"/"])
                {
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    [self.string setString:@""];//字符串清零
                    self.str=[button currentTitle];//保存运算符为了作判断作何种运算
                    NSLog(@"%@",_str);
                    [self.string appendString:self.str];
                    [self.string setString:@""];//字符串清零
                }
            }
            else if([self.str hasPrefix:@"*"])//之前的符号是*   hasPrefix:方法的功能是判断创建的字符串内容是否以某个字符开始
            {
                [self.string setString:@""];//字符串清零
                self.num2*=self.num1;
                //输出上次结果后判断这次输入的是何符号
                if ([[button currentTitle] isEqualToString:@"="])
                {
                    NSLog(@"self.num2 is %f",self.num2);
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    self.str=@"";
                }
                else if ([[button currentTitle]isEqualToString:@"+"]||[[button currentTitle]isEqualToString:@"-"]||[[button currentTitle]isEqualToString:@"*"]||[[button currentTitle]isEqualToString:@"/"])
                {
                    NSLog(@"self.num2 is %f",self.num2);
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    [self.string setString:@""];          //字符串清零
                    self.str=[button currentTitle];       //保存运算符为了作判断作何种运算
                    NSLog(@"%@",_str);
                    [self.string appendString:self.str];  //在字符串后增加新的东西，［a appendString:]
                    [self.string setString:@""];          //字符串清零
                }
            }
            
            else if ([self.str isEqualToString:@"/"])//之前的符号是/
            {
                [self.string setString:@""];//字符串清零
                self.num2/=self.num1;
                //判断输出上次结果后判断这次输入的是何符号
                if ([[button currentTitle]isEqualToString:@"="])
                {
                    NSLog(@"self.num2  is  %f",self.num2);
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    self.str=@"";
                }
                else if ([[button currentTitle]isEqualToString:@"+"]||[[button currentTitle]isEqualToString:@"-"]||[[button currentTitle]isEqualToString:@"*"]||[[button currentTitle]isEqualToString:@"/"])
                {
                    self.label.text=[NSString stringWithFormat:@"%.1f",self.num2];
                    [self.string setString:@""];//字符串清零
                    self.str=[button currentTitle];//保存运算符为了作判断作何种运算
                    NSLog(@"%@",_str);
                    [self.string appendString:self.str];
                    [self.string setString:@""];//字符串清零
                }
                
            }
        }
        
    }else if(button.tag == 0){//按下清楚键时，清空所有的字符串
        [self.string setString:@""];//清空字符
        self.num1=0;
        self.num2=0;
        self.label.text=@"0";//保证下次输入时清零
    }else if (button.tag == 1){
        if (![self.label.text isEqualToString:@""])//判断不是空
        {
            [self.string1 appendString:self.label.text];
            [_string1 deleteCharactersInRange:NSMakeRange
             (_string1.length - 1,1)];//删除最后一个字符
            self.label.text=[NSString stringWithString:_string1];//显示结果
            self.string1 = nil;//清空字符串
        }
    }
}


@end
