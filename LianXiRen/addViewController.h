//
//  addViewController.h
//  tongxunluFMDB
//
//  Created by mac on 17/11/19.
//  Copyright (c) 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface addViewController : UIViewController

@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) int ID;


@end
