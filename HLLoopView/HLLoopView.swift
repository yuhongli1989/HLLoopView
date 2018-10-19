//
//  HLLoopView.swift
//  HLLoopView
//
//  Created by yunfu on 2018/10/17.
//  Copyright © 2018年 yunfu. All rights reserved.
//

import UIKit

class HLLoopView<Item:HLLoopViewItem>: UIView,UICollectionViewDelegate,UICollectionViewDataSource {

    lazy var contentView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let v = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        v.isPagingEnabled = true
        v.register(UINib(nibName: "HLLoopCell", bundle: nil), forCellWithReuseIdentifier: "loopCell")
        v.delegate = self
        v.dataSource = self
        return v
    }()
    typealias LoopBlock = (_ page:Int,_ item:Item)->Void
    var didSelected:LoopBlock?
    var currentPageBack:LoopBlock?
    var loopTimeInterval:Double = 3
    var items:[Item] = []
    private var currentPage:Int = 0
    var pageIndex:Int {
        if currentPage == 0 {
            return items.count - 3
        }else if currentPage == items.count-1{
            return 0
        }
        return currentPage - 1
    }
    private var timer:Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(contentView)
    }
    
    func setModels(_ models:[Item],_ isLoop:Bool)  {
        guard let first = models.last,
              let last = models.first else {
            return
        }
        var arr = models
        arr.append(last)
        arr.insert(first, at: 0)
        items = arr
        timer?.invalidate()
        timer = nil
        currentPage = 1
        DispatchQueue.main.async {
            self.contentView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        currentPageBack?(pageIndex,items[currentPage])
        if isLoop && items.count>0 {
            timer = Timer.hl_scheduledTimer(withTimeInterval: loopTimeInterval, mode: .common, repeats: true, block: { [weak self] in
                
                self?.loopFunc()
                
            })
        }
        contentView.reloadData()
    }
    
    private func loopFunc()  {
        currentPage+=1
        
        contentView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelected?(pageIndex,items[currentPage])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loopCell", for: indexPath) as! HLLoopCell
        cell.setModel(items[indexPath.row])
        return cell
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        
        if timer?.isValid == true {
            //关闭定时器
            timer?.fireDate = Date.distantFuture
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x/scrollView.bounds.width == 0 {
            //最后一张
            scrollView.contentOffset.x = scrollView.bounds.width*CGFloat(items.count-2)
        }else if scrollView.contentOffset.x/scrollView.bounds.width == CGFloat(items.count-1){
            //第一张
            scrollView.contentOffset.x = scrollView.bounds.width
        }
        currentPage = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        //滑动后2秒后开启定时器
        if timer?.isValid == true {
            timer?.fireDate = Date(timeInterval: 2, since: Date())
        }
        currentPageBack?(pageIndex,items[currentPage])
        
    }
    
    
   
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x/scrollView.bounds.width == 0 {
            //最后一张
            scrollView.contentOffset.x = scrollView.bounds.width*CGFloat(items.count-2)
        }else if scrollView.contentOffset.x/scrollView.bounds.width == CGFloat(items.count-1){
            //第一张
            scrollView.contentOffset.x = scrollView.bounds.width
        }
        currentPage = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        currentPageBack?(pageIndex,items[currentPage])
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol HLLoopViewItem {
    var urlStr:String{get set}
}


