//
//  ViewController.swift
//  10.1-3
//
//  Created by 田子瑶 on 16/6/28.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var img:UIImageView!
    var imgLeft:UIImageView!
    var imgRight:UIImageView!
    
    var cmm:CMMotionManager!
    
    var rotateX:CGFloat!  //累计旋转值 陀螺仪旋转量累计加在里面
    var imgWidth:CGFloat!
    var imgHeight:CGFloat!
    
    let myQue = NSOperationQueue.mainQueue()
//    let myQue = NSOperationQueue.currentQueue()!
    
    let imgName = UIImage(named: "1.jpg")

    override func viewDidLoad() {
        super.viewDidLoad()

        rotateX = 0
        cmm = CMMotionManager()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        loadImg()
    
    }
    
    func loadImg() {
        
        img = UIImageView.init(image: imgName)
        
        imgWidth = img.bounds.width
        imgHeight = img.bounds.height
        
        print("宽度\(imgWidth) 高度\(imgHeight)")
        
        //计算屏幕高度和图片高度的比例 用来缩放图片
        let sizeRect = UIScreen.mainScreen().bounds.height/imgHeight
        
        imgWidth = imgWidth * sizeRect
        imgHeight = imgHeight * sizeRect
        
        img.frame.size = CGSizeMake(imgWidth, imgHeight)
        img.center = self.view.center//图片居中
        
        self.view.addSubview(img)
        
        let leftImgCenterX = img.center.x - imgWidth
        let rightImgCenterX = img.center.x + imgWidth
        let imgCenterY = img.center.y
        
        imgLeft = UIImageView.init(image: imgName)
        imgLeft.center = CGPointMake(leftImgCenterX, imgCenterY)
        imgLeft.frame.size = CGSizeMake(imgWidth, imgHeight)
        
        imgRight = UIImageView.init(image: imgName)
        imgRight.center = CGPointMake(rightImgCenterX, imgCenterY)
        imgRight.frame.size = CGSizeMake(imgWidth, imgHeight)
        
        self.view.addSubview(imgLeft)
        self.view.addSubview(imgRight)
        
        print("\(leftImgCenterX) \(img.center.x) \(rightImgCenterX) ")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        startGyro()
        print("陀螺仪已启用")
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopGyro()
    }
    
    func startGyro() {
        
        cmm.gyroUpdateInterval = 1/50
        
            cmm.startGyroUpdatesToQueue(myQue, withHandler: { (data:CMGyroData?, error:NSError?) in
                self.rotatePhone(data!)
//                print("准备移动图片")
            })
        
    }
    
    func stopGyro() {

        if cmm.gyroAvailable {
            cmm.stopGyroUpdates()
        }
    }
    
    func rotatePhone(data:CMGyroData) {
        
        // 9这个数字可以改变 主要保证360度旋转以后可以回到起点
        rotateX = rotateX + CGFloat(data.rotationRate.x) * 9
    
        if rotateX < -1 * imgWidth/2 {
            
            rotateX = rotateX + imgWidth
            self.img.center = self.imgRight.center
            print("中间的image向右偏移一个单位")
            
        }
        else if rotateX > imgWidth/2 {
        
            rotateX = rotateX - imgWidth
            self.img.center = self.imgLeft.center
            print("中间的image向左偏移一个单位")

        }
        else{
        
            let centerX = self.view.center.x + rotateX
            let centerY = self.view.center.y
            self.img.center = CGPointMake(centerX, centerY)
        }
        
//        print(rotateX)
        
        movePic()
    }
    
    func movePic() {
        
        let leftX = img.center.x - imgWidth
        let rightX = img.center.x + imgWidth
        let imgY = img.center.y
        
        imgLeft.center = CGPointMake(leftX, imgY)
        imgRight.center = CGPointMake(rightX, imgY)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

