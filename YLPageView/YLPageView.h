//
//  YLPageView.h
//  ForeignerHome
//
//  Created by eviloo7 on 16/2/16.
//  Copyright © 2016年 蓝海软通. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,YLPageViewStyle) {
    YLPageViewStyleIcon,
    YLPageViewStyleImage,
};
@protocol YLPageViewDelegate <NSObject>

@optional
-(void)pageViewClick:(NSUInteger)tagNumber;
@end
@interface YLPageView : UIImageView
/**
 *  设置有几页
 */
@property (nonatomic,assign) NSUInteger pageNumber;
/**
 *  设置小图标一行有多少
 */
@property (nonatomic,assign) NSUInteger iconRowNumber;
/**
 *  设置文字
 */
@property (nonatomic,copy) NSArray *dataText;
/**
 *  设置图片，在icon中这个尺寸要合理摇
 */
@property (nonatomic,copy) NSArray *dataImages;
/**
 *  代理
 */
@property (nonatomic,weak)id<YLPageViewDelegate>delegate;
/**
 *  设置样式
 */
@property (nonatomic,assign) YLPageViewStyle pageViewStyle;
/**
 *  设置指示豆的颜色
 */
@property (nonatomic,weak)UIColor *IndicatorColor;
/**
 *  设置当前指示豆的颜色
 */
@property (nonatomic,weak)UIColor *currentIndicatorColor;
/**
 *  设置是否自动循环，只对图片有效
 */
@property (nonatomic,assign,getter=isAutoRepeat)BOOL autoRepeat;
@end
