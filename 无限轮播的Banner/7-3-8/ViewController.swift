//
//  ViewController.swift
//  7-3-8
//
//  Created by 田子瑶 on 16/6/13.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var banner:BannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        banner = BannerView(frame: self.view.frame)
        
        banner.setBannerImages(["1.jpg","2.jpg","3.jpg","4.jpg",])
        
        self.view.addSubview(banner)
        
        

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

