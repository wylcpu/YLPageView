//
//  YLPageView.m
//  ForeignerHome
//
//  Created by eviloo7 on 16/2/16.
//  Copyright © 2016年 蓝海软通. All rights reserved.
//

#import "YLPageView.h"

@interface YLPageView() <UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSUInteger _currentPage;
    NSTimer *_timer;
    
    NSMutableArray *_container;
    
}
@end
@implementation YLPageView
- (instancetype) init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.autoRepeat = NO;
        [self addView];
        _container = [NSMutableArray new];
    }
    return self;
}
#pragma mark - 添加视图
- (void)addView {
    UIScrollView *scrollView                  = [[UIScrollView alloc] init];
    scrollView.pagingEnabled                  = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.bounces                        = NO;
    scrollView.delegate                       = self;
    [self addSubview:scrollView];
    _scrollView                               = scrollView;

    UIPageControl *pageControl                = [[UIPageControl alloc] init];
    pageControl.currentPage                   = 0;
    pageControl.pageIndicatorTintColor        = [UIColor colorWithWhite:0.680 alpha:1.000];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:201/255 blue:175/255 alpha:1.f];
    pageControl.hidesForSinglePage            = YES;
    [self addSubview:pageControl];
    _pageControl                              = pageControl;
    
}
#pragma mark - 动态加载
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _scrollView.frame = self.bounds;
}

- (void)setPageNumber:(NSUInteger)pageNumber {
    _pageNumber                = pageNumber;
}

- (void)setAutoRepeat:(BOOL)autoRepeat {
    _autoRepeat =autoRepeat;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _pageControl.numberOfPages = _pageNumber;
    if (_pageNumber > 1) {
        if (self.isAutoRepeat) {
            _scrollView.contentSize    = CGSizeMake(self.bounds.size.width * (_pageNumber+2), self.bounds.size.height);
        } else {
            _scrollView.contentSize = CGSizeMake(self.bounds.size.width*self.pageNumber, self.bounds.size.height);
        }
    } else {
        _scrollView.contentSize     =CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }
    
    _pageControl.frame = CGRectMake(0, self.bounds.size.height -20, self.bounds.size.width, 20);
   
    if (self.pageViewStyle == YLPageViewStyleIcon) {
        if (self.isAutoRepeat) {
          
        } else {
           [self addNoRepeatPageBtn];
        }
        
    }
    if (self.pageViewStyle == YLPageViewStyleImage) {
        if (self.isAutoRepeat) {
           [self addRepeatImageView];
        } else {
            [self addNoRepeatImageView];
        }
    }
}
- (void)addRepeatImageView {
    
        for (NSUInteger i=0; i<self.pageNumber+2; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            imageView.frame = CGRectMake(self.bounds.size.width*i, 0, self.bounds.size.width, self.bounds.size.height);
            //        [imageView sd_setImageWithURL:[NSURL URLWithString:_dataImages[i]] placeholderImage:[UIImage imageNamed:@"liqin_5"]];
            if (i==0) {
               imageView.image = [UIImage imageNamed:self.dataImages[self.pageNumber-1]];
            } else if(i == self.pageNumber+1) {
                imageView.image = [UIImage imageNamed:self.dataImages[0]];
            } else {
                imageView.image = [UIImage imageNamed:self.dataImages[i-1]];
            }
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
            [tapGR addTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:tapGR];
            [_scrollView addSubview:imageView];
        }
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    _currentPage = 1;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timerRepeat:) userInfo:nil repeats:YES];
    }
    
    
}
- (void)addNoRepeatImageView {
    for (NSUInteger i=0; i<self.pageNumber; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(self.bounds.size.width *i, 0, self.bounds.size.width, self.bounds.size.height);
        //        [imageView sd_setImageWithURL:[NSURL URLWithString:_dataImages[i]] placeholderImage:[UIImage imageNamed:@"liqin_5"]];
        imageView.image = [UIImage imageNamed:self.dataImages[i]];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        [tapGR addTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tapGR];
        [_scrollView addSubview:imageView];
    }
    
}
- (void)timerRepeat:(id)sender {
    _currentPage ++;
    if (self.pageNumber+1 == _currentPage) {
        [_scrollView setContentOffset:CGPointMake( self.bounds.size.width*_currentPage,0) animated:YES];
        _pageControl.currentPage = 0;
    } else if(_currentPage == 0) {
        [_scrollView setContentOffset:CGPointMake( self.pageNumber,0) animated:YES];
        _pageControl.currentPage = self.pageNumber-1;
        
    } else {
        [_scrollView setContentOffset:CGPointMake( self.bounds.size.width * _currentPage,0) animated:YES];
        _pageControl.currentPage = _currentPage-1;
    }
}

- (void)addNoRepeatPageBtn {
    CGFloat width = self.bounds.size.width/self.iconRowNumber;
    CGFloat height = (self.bounds.size.height-20)/ceilf(self.dataText.count/1./self.iconRowNumber);
    for (NSUInteger k=0; k<self.pageNumber; k++) {
        for (NSUInteger i = 0; i<self.dataText.count; i++) {
            UIButton *btn       = [[UIButton alloc] init];
            [btn setTitle:self.dataText[i+k*self.pageNumber] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:self.dataImages[i+k*self.pageNumber]] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor redColor]];
            btn.frame           = CGRectMake(i%self.iconRowNumber*width+self.bounds.size.width*k,height*(i/self.iconRowNumber), width, height);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            CGRect titleRect = btn.titleLabel.frame;
            CGRect imageRect = btn.imageView.frame;
            CGFloat padding = 15;
            CGFloat selfHeight = btn.frame.size.height;
            CGFloat selfWidth = btn.frame.size.width;
            CGFloat totalHeight = titleRect.size.height +padding +imageRect.size.height;
            [btn setTitleColor:[UIColor colorWithRed:0.247 green:0.239 blue:0.227 alpha:1.000] forState:UIControlStateNormal];

            btn.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                   (selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2,
                                                   -((selfHeight - totalHeight)/2 + imageRect.size.height + padding - titleRect.origin.y),
                                                   -(selfWidth/2 - titleRect.origin.x - titleRect.size.width /2) - (selfWidth - titleRect.size.width) /2);
            btn.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                   (selfWidth /2 - imageRect.origin.x - imageRect.size.width /2),
                                                   -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                                   -(selfWidth /2 - imageRect.origin.x - imageRect.size.width /2));
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
        }
    }
}


#pragma - mark YLPageViewDelegate
- (void)tapImageView:(UIGestureRecognizer *)sender {
    UIImageView *view = (UIImageView*)[sender view];
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewClick:)]) {
        [_delegate pageViewClick:view.tag];
    }
}
- (void)clickBtn:(UIButton *)sender {
   
    if (_delegate && [_delegate respondsToSelector:@selector(pageViewClick:)]) {
        [_delegate pageViewClick:sender.tag];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger currentPage = scrollView.contentOffset.x/self.bounds.size.width;
    _currentPage = currentPage;
    if (self.isAutoRepeat) {
        if (_currentPage == 0) {
            _currentPage = self.pageNumber;
            [_scrollView setContentOffset:CGPointMake(self.pageNumber*self.bounds.size.width, 0)];
            _pageControl.currentPage = self.pageNumber-1;
        } else if(_currentPage == self.pageNumber+1) {
            _currentPage = 1;
            [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
            _pageControl.currentPage = 0;
        } else {
            _pageControl.currentPage = _currentPage-1;
        }
        
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(timerRepeat:) userInfo:nil repeats:YES];
        }
        
    } else {
        _pageControl.currentPage = _currentPage;
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.isAutoRepeat) {
        if (_currentPage == 0) {
            _currentPage = self.pageNumber;
            [_scrollView setContentOffset:CGPointMake(self.pageNumber*self.bounds.size.width, 0)];
            _pageControl.currentPage = self.pageNumber-1;
        } else if(_currentPage == self.pageNumber+1) {
            _currentPage = 1;
            [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
            _pageControl.currentPage = 0;
        } else {
            _pageControl.currentPage = _currentPage-1;
        }
    } else {
        _pageControl.currentPage = _currentPage;
    }

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

/**
 *  计算text文本的宽高
 *
 *  @param text  text description
 *  @param width width description
 *  @param font  font description
 *
 *  @return 文本的大小
 */
- (CGSize) getStringSize:(NSString *)text showWidth:(CGFloat)width font:(UIFont *)font {
    
    NSDictionary *dict = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
}
@end
