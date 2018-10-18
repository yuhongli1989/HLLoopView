//
//  ExtensionTimer.swift
//  HLLoopView
//
//  Created by yunfu on 2018/10/17.
//  Copyright © 2018年 yunfu. All rights reserved.
//

import Foundation
var hl_blockKey = "hl_blockKey"
extension Timer{
    
    @discardableResult
    open class func hl_scheduledTimer(timeInterval:
        TimeInterval, target:
        Any, selector:
        Selector, userInfo:
        Any?, repeats:
        Bool)->Timer{
        
        let t = TimerTarget()
        
        let imp = class_getMethodImplementation(object_getClass(target), selector)
        let method = class_getInstanceMethod(object_getClass(target), selector)
        let type = method_getTypeEncoding(method!)
        if let _ = class_getInstanceMethod(object_getClass(t), selector){
            
        }else{
            class_addMethod(object_getClass(t), selector, imp!, type)
        }

        return Timer.scheduledTimer(timeInterval: timeInterval, target: t, selector: selector, userInfo: userInfo, repeats: repeats)
        
    }
    
    open class func hl_scheduledTimer(withTimeInterval: TimeInterval,mode:RunLoop.Mode = .default, repeats: Bool, block: @escaping () -> Void)->Timer{
        let t = TimerTarget()
        let timer = Timer(timeInterval: withTimeInterval, target: t, selector: #selector(TimerTarget.blockFunc(_:)), userInfo: nil, repeats: repeats)
        timer.hl_timerBlock = block
        RunLoop.main.add(timer, forMode: mode)
        return timer
    }
    
    fileprivate var hl_timerBlock:(() -> Void)?{
        set{
            objc_setAssociatedObject(self, &hl_blockKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            if let block = objc_getAssociatedObject(self, &hl_blockKey) as? (() -> Void){
                return block
            }
            return nil
        }
    }
    
    
}

fileprivate class TimerTarget: NSObject {
    
    @objc func blockFunc(_ timer:Timer){
        timer.hl_timerBlock?()
    }
    
    deinit {
        print("TimerTarget deinit")
    }
}

