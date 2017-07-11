//
//  MGFiltrateView.h
//  CheDaiBao
//
//  Created by zzw on 17/5/23.
//  Copyright © 2017年 MG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGFiltrateViewDelegate <NSObject>

- (void)filtrateConfirmWithDic:(NSDictionary *)dic;

@end

@interface MGFiltrateView : UIView

@property (nonatomic,weak)id<MGFiltrateViewDelegate>delegate;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)showView;

- (void)hideView;

@end
