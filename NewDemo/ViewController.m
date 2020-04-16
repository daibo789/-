//
//  ViewController.m
//  NewDemo
//
//  Created by slowdony on 2020/3/30.
//  Copyright © 2020 slowdony. All rights reserved.
//

#import "ViewController.h"
#import "NewDemo-Swift.h"
@interface ViewController ()
@property (strong ,nonatomic) test1ViewController *tttt;
@property (strong ,nonatomic) FloatButton *bgView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tttt = [test1ViewController new];
    _bgView =  [[FloatButton alloc] init:1 bgColor:UIColor.greenColor radiuOfButton:0 titleOfButton:@"" titleColorOfButton:UIColor.grayColor];
    _bgView.frame = CGRectMake(100, 100, 100, 100);
    _tttt.dismissBlock = ^(BOOL res) {
        if (res) {
            [_tttt dismissViewControllerAnimated:NO completion:^{
                self->_tttt.view.frame = _bgView.bounds;
                [_bgView addSubview:_tttt.view];
                _tttt.view.userInteractionEnabled = NO;
                [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
                _bgView.hidden = NO;
            }];
            
        }else{
          
//            _tttt.view.removeFromSuperview;
            _bgView.hidden = YES;
            [self presentViewController:_tttt animated:YES completion:nil];
//            [self presentBottom:_tttt];
        }
    };
}
- (IBAction)zhujiao:(id)sender {
//    [[TIMHelper shared] callUsersWithUserIds:@[@"15202917912"]];
//    [self presentBottom:_tttt];
//    _tttt.view.removeFromSuperview;
    [self presentViewController:_tttt animated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


@end
