//
//  ViewController.swift
//  HLLoopView
//
//  Created by yunfu on 2018/10/17.
//  Copyright © 2018年 yunfu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    

    lazy var loopView:HLLoopView<loopModel> = {
        let v = HLLoopView<loopModel>(frame: self.view.bounds)
        
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loopView)
        loopView.currentPageBack = { (page,item) in
            print("page===\(page), item==\(item)")
        }
        let arr = [loopModel(urlStr: "1.jpg"),loopModel(urlStr: "2.jpg"),loopModel(urlStr: "3.jpg"),loopModel(urlStr: "4.jpg")]
        loopView.setModels(arr, true)
        
    }
    
    

    @objc func abc()  {

    }

}


struct loopModel:HLLoopViewItem {
    var urlStr:String
}
