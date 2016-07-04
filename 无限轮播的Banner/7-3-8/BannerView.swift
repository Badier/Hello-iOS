//
//  BannerView.swift
//  7-3-8
//
//  Created by 田子瑶 on 16/6/13.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

public class BannerView: UIView,UIScrollViewDelegate {
    
    private var timer:NSTimer!  //计时器
    private let MinimumTimeInterval = 1.5  //轮播间隔
    
    public var autoScroll = true //自动轮播
    
    public var autoScrollTimeInterval = 1.5{
        
        didSet{
            
            if autoScrollTimeInterval<MinimumTimeInterval{
                autoScrollTimeInterval = MinimumTimeInterval
            }
            
            if autoScroll{
                self.stopTimer()
                self.startTimer()
            }
        }
    }
    
    
    
    public var pageControlEnabled = true
    public var pageIndicatorColor = UIColor.whiteColor()
    public var currentPageIndicatorColor = UIColor.blackColor()
    
    private var pageControl:UIPageControl!
    private func loadPageControl()->UIPageControl{
        
        let pageControlHeight:CGFloat = 50
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: self.hetght-40, width: self.width, height: pageControlHeight))
        
        pageControl.numberOfPages = self.images.count-2
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.redColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blueColor()
        
        return pageControl
        
    }
    
    private var scrollView:UIScrollView!
    
    private func loadScrollView()->UIScrollView{
        
        let _scrollView = UIScrollView(frame: self.frame)
        
        for (index, imageName) in self.images.enumerate(){
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRectMake(CGFloat(index)*self.width, self.frame.origin.y, self.width, self.hetght)
            imageView.contentMode = .ScaleAspectFill
            imageView.userInteractionEnabled = true //是否接收并响应用户交互
            imageView.clipsToBounds = true
            _scrollView .addSubview(imageView)
        }
        
        _scrollView.userInteractionEnabled = true
        /*
        UIScrollView的类可以有必须采取UIScrollViewDelegate协议的委托。
        对于缩放和平移工作，委托必须实现viewForZoomingInScrollView ：和scrollViewDidEndZooming ： withView ： atScale ：
        此外，最大（ maximumZoomScale ）和最小（ minimumZoomScale ）变焦倍数必须是不同的。
        */
        _scrollView.delegate = self
        //BOOL pagingEnabled 控制控件是否整页翻动
        _scrollView.pagingEnabled = true
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.showsVerticalScrollIndicator = false
        /*
        contentSize、contentInset和contentOffset 是 scrollView三个基本的属性。
        
        contentSize: The size of the content view.
        其实就是scrollview可以滚动的区域，比如frame = (0 ,0 ,320 ,480) contentSize = (320 ,960)，
        代表你的scrollview可以上下滚动，滚动区域为frame大小的两倍。
        
        contentOffset:The point at which the origin of the content view is offset from the origin of the scroll view.
        是scrollview当前显示区域顶点相对于frame顶点的偏移量，
        比如上个例子你拉到最下面，contentoffset就是(0 ,480)，也就是y偏移了480
        
        contentInset:The distance that the content view is inset from the enclosing scroll view.
        是scrollview的contentview的顶点相对于scrollview的位置，
        例如你的contentInset = (0 ,100)，那么你的contentview就是从scrollview的(0 ,100)开始显示
        */
        _scrollView.contentSize = CGSize(width: self.width*CGFloat(self.images.count), height: self.hetght)
        _scrollView.contentOffset = CGPoint(x: self.width, y: 0)
        
        return _scrollView
        
    }
    
    private var width:CGFloat{
        return self.frame.width
    }
    
    private var hetght:CGFloat{
        return self.frame.height/4
    }
    
    private var images:[String]{
        
        didSet{
            
            for subview in self.subviews{
                subview .removeFromSuperview()
            }
            
            self.scrollView = loadScrollView()
            self.addSubview(scrollView)
            
            if pageControlEnabled{
                self.pageControl = loadPageControl()
                self.addSubview(pageControl)
            }
            
            if autoScroll{
                self.startTimer()
            }
        }
    }
    
    private func startTimer(){
        
        if timer == nil{
            timer = NSTimer.scheduledTimerWithTimeInterval(autoScrollTimeInterval, target: self,
                selector: "scrollToNextPage", userInfo: nil, repeats: true)
        }
    }
    
    private func stopTimer(){
        
        timer.invalidate()// [timer invalidate]是唯一的方法将定时器从循环池中移除
        timer = nil

        
    }
    
    /*
    在Swift类型文件中，我们可以将需要暴露给Objective-C使用的任何地方（包括类，属性和方法等）的声明前面加上@objc修饰符。
    注意这个步骤只需要对那些不是继承自NSObject的类型进行，如果你用Swift写的class是继承自NSObject的话，
    Swift会默认自动为所有的非private的类和成员加上@objc。
    这就是说，对一个NSObject的子类，你只需要导入相应的头文件就可以在Objective-C里使用这个类了。
    */
    
    @objc private func scrollToNextPage(){
        
        let currentOffSet = self.scrollView.contentOffset
        let nextOffSet = CGPoint(x: currentOffSet.x+self.width, y: 0)
        
        //在UIScrollView,setContentOffset方法的功能是跳转到你指定内容的坐标,
        self.scrollView.setContentOffset(nextOffSet, animated: true)
        
        if let pageControl = self.pageControl{
            pageControl.currentPage = (pageControl.currentPage+1)%(self.images.count-2)
        }
    }
    
    //初始化
    public required init?(coder aDecoder: NSCoder) {
        self.images = []
        super.init(coder: aDecoder)
    }
    
    override public init(frame: CGRect) {
        self.images = []
        super.init(frame: frame)
    }
    
    public func setBannerImages(imagesArray:[String]){
        // 0 123 4
        var tempArray = [String]()
        tempArray.append(imagesArray.last!)
        tempArray.appendContentsOf(imagesArray)
        tempArray.append(imagesArray.first!)
        self.images = tempArray
        // 4 01234 0
    }
    
    //scrollView滚动时，就调用该方法。任何offset值改变都调用该方法。即滚动过程中，调用多次
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        
        if offsetX==0{
        scrollView.contentOffset = CGPoint(x: width*CGFloat(self.images.count-2), y: 0)
        }
        else if offsetX==width*CGFloat(self.images.count-1){
        scrollView.contentOffset = CGPoint(x: width, y: 0)
        }
        
        let currentPage = scrollView.contentOffset.x/width-0.5
        
        if let pageControl = self.pageControl{
            pageControl.currentPage = Int(currentPage)
        }
        
    }
    
    // 当开始滚动视图时，执行该方法。一次有效滑动（开始滑动，滑动一小段距离，只要手指不松开，只算一次滑动），只执行一次。
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.stopTimer()
    }
    // 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
    // decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startTimer()
    }
    
    
}
