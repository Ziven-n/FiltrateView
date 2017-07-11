//
//  MGFiltrateView.m
//  CheDaiBao
//
//  Created by zzw on 17/5/23.
//  Copyright © 2017年 MG. All rights reserved.
//

#import "MGFiltrateView.h"

@interface MGFiltrateView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSMutableArray *firstArray;

@property (nonatomic,strong) NSMutableArray *secondArray;
@end

#define myWidth  (kScreenW - AdaptW(80))

@implementation MGFiltrateView

- (instancetype)initWithDic:(NSDictionary *)dic {
    
    self = [super initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    
    [self addGesture];
    
    [self configUIWithDic:dic];
    
    return self;
}

- (void)configUIWithDic:(NSDictionary *)dic {
    
    self.dataDic = dic;
    
    // 这个是系统提供的布局类，可以布局一些比较规则的布局。
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每个item的大小，
    flowLayout.itemSize = CGSizeMake(myWidth/3 - 20, AdaptH(40));
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 10;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(self.frame.size.width, AdaptH(30)); //设置collectionView头视图的大小
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kScreenW, 0, myWidth, kScreenH) collectionViewLayout:flowLayout];
    // 如果未设置背景颜色是黑色设置背景颜色
    _collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    // 向下偏移20;
    _collectionView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CELL"];
    
    //注册header单元格
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
    
    [self addSubview:_collectionView];
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenH - kTabBarHeight - 21, myWidth, 1)];
    lineLable.backgroundColor = UIColorFromHex(0x1b82d2);
    [_collectionView addSubview:lineLable];
    
    
    NSArray *titleArray = @[@"重置",@"确定"];
    
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(myWidth/2*i, kScreenH - kTabBarHeight - 20, myWidth/2, kTabBarHeight);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(resultButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = Font_Normal_16;
        
        if (i == 0) {
            [button setTitleColor:UIColorFromHex(0x1b82d2) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
        }else {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = UIColorFromHex(0x1b82d2);
        }
        [_collectionView addSubview:button];
    }
}

#pragma mark - 重置/确定
- (void)resultButtonAction:(UIButton *)button {
    
    switch (button.tag) {
        case 0:{
            
            [self resetMybutton];
            
        }
            break;
        case 1:{
            
            [self hideView];
            
            [self confirm];
        }
            break;
            
        default:
            break;
    }
}

- (void)resetMybutton {
    
    for (UIButton *mybutton in _firstArray) {
        if (mybutton.selected) {
            mybutton.selected = NO;
            mybutton.backgroundColor = [UIColor whiteColor];
        }
    }
    for (UIButton *mybutton in _secondArray) {
        if (mybutton.selected) {
            mybutton.selected = NO;
            mybutton.backgroundColor = [UIColor whiteColor];
        }
    }
}

- (void)confirm {
    
    NSMutableArray *array1 = @[].mutableCopy;
    NSMutableArray *array2 = @[].mutableCopy;
    
    for (UIButton *mybutton in _firstArray) {
        if (mybutton.selected) {
            switch (mybutton.tag) {
                case 0:{
                    [array1 addObject:@1];
                    break;
                }
                case 1:{
                    [array1 addObject:@2];
                    break;
                }
                case 2:{
                    [array1 addObject:@3];
                    break;
                }
                case 3:{
                    [array1 addObject:@5];
                    break;
                }
                case 4:{
                    [array1 addObject:@6];
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
    for (UIButton *mybutton in _secondArray) {
        if (mybutton.selected) {
            [array2 addObject:@(mybutton.tag)];
        }
    }

    NSDictionary *dic = @{
                          @"state":array1,
                          @"isWireless":array2
                          };
    
    if ([_delegate respondsToSelector:@selector(filtrateConfirmWithDic:)]) {
        [_delegate filtrateConfirmWithDic:dic];
    }
    
}

#pragma mark - UICollectionViewDelegate

// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return _dataDic.allKeys.count;
}

// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return ((NSArray *)_dataDic[_dataDic.allKeys[section]]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL" forIndexPath:indexPath];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    button.tag = indexPath.row;
    [button.titleLabel setFont:Font_Normal_14];
    button.frame = cell.bounds;
    button.layer.borderColor = UIColorFromHex(0x1b82d2).CGColor;
    button.layer.borderWidth = 1;
    [button setTitleColor:UIColorFromHex(0x1b82d2) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitle:_dataDic[_dataDic.allKeys[indexPath.section]][indexPath.row] forState:UIControlStateNormal];
    
    if (indexPath.section == 0) {
        NSString *stateStr = [MGUserDefaultsManager getFiltrateStatus];
        NSInteger mystr = 1000;
        [button addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
        [self.firstArray addObject:button];
        
        switch ([stateStr integerValue]) {
            case 1:{
                mystr = 0;
                break;
            }
            case 2:{
                mystr = 1;
                break;
            }
            case 3:{
                mystr = 2;
                break;
            }
            case 5:{
                mystr = 3;
                break;
            }
            case 6:{
                mystr = 4;
                break;
            }
            default:
                break;
        }
        
        if (indexPath.row == mystr) {
            button.selected = YES;
            [button setBackgroundColor:UIColorFromHex(0x1b82d2)];
        }
        
    }else if (indexPath.section == 1) {
        
        NSString *wirelessStr = [MGUserDefaultsManager getFiltrateWiress];
        [button addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
        [self.secondArray addObject:button];
        if ([wirelessStr integerValue] == indexPath.row) {
            button.selected = YES;
            [button setBackgroundColor:UIColorFromHex(0x1b82d2)];
        }
    }
    
    [cell.contentView addSubview:button];
    
    return cell;
}


//返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, myWidth/3 - 30, AdaptH(30))];
        lable.text =_dataDic.allKeys[indexPath.section];
        lable.font = Font_Normal_15;
        
        //头视图添加view
        [header addSubview:lable];
        
        return header;
    }
    return nil;
}

#pragma mark - 给self添加手势
- (void)addGesture {
    
    self.alpha = 0;
    
    self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    
    [KeyWindow addSubview:self];
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    ges.delegate = self;
    [self addGestureRecognizer:ges];
    
    UISwipeGestureRecognizer *swipGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self addGestureRecognizer:swipGes];
    
}
#pragma mark - 显示隐藏动画
- (void)showView {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.alpha = 1;
        
        _collectionView.frame = CGRectMake(AdaptW(80), 0, kScreenW - AdaptW(80), kScreenH);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideView {
    
    [UIView animateWithDuration:.3 animations:^{
        
        self.alpha = 0;
        
        _collectionView.frame = CGRectMake(kScreenW, 0, kScreenW - AdaptW(80), kScreenH);
        
    } completion:^(BOOL finished) {
        
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //如果是_collectionView的子视图
    if ([touch.view isDescendantOfView:_collectionView]) {
        return NO;
    }
    return YES;
}

#pragma mark - 按钮切换逻辑

- (void)button1Action:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
        [button setBackgroundColor:UIColorFromHex(0x1b82d2)];
    }else {
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    
    for (UIButton *mybutton in _firstArray) {
        
        if (mybutton.tag == button.tag) {
            
            if (mybutton.selected) {
                
                mybutton.selected = YES;
                [mybutton setBackgroundColor:UIColorFromHex(0x1b82d2)];
                
            }else {
                mybutton.selected = NO;
                [mybutton setBackgroundColor:[UIColor whiteColor]];
            }
        }else {
            mybutton.selected = NO;
            [mybutton setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

- (void)button2Action:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
        [button setBackgroundColor:UIColorFromHex(0x1b82d2)];
    }else {
        [button setBackgroundColor:[UIColor whiteColor]];
    }
    
    for (UIButton *mybutton in _secondArray) {
        
        if (mybutton.tag == button.tag) {
            if (mybutton.selected) {
                
                mybutton.selected = YES;
                [mybutton setBackgroundColor:UIColorFromHex(0x1b82d2)];
                
            }else {
                mybutton.selected = NO;
                [mybutton setBackgroundColor:[UIColor whiteColor]];
            }

        }else {
            mybutton.selected = NO;
            [mybutton setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

#pragma mark - 初始化数组

- (NSMutableArray *)firstArray {
    if (!_firstArray) {
        _firstArray = @[].mutableCopy;
    }
    return _firstArray;
}

- (NSMutableArray *)secondArray {
    if (!_secondArray) {
        _secondArray = @[].mutableCopy;
    }
    return _secondArray;
}

@end
