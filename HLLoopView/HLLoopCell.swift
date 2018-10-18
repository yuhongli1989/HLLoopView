//
//  HLLoopCell.swift
//  HLLoopView
//
//  Created by yunfu on 2018/10/17.
//  Copyright © 2018年 yunfu. All rights reserved.
//

import UIKit
import SDWebImage

class HLLoopCell: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setModel(_ model:HLLoopViewItem)  {
        if model.urlStr.hasPrefix("http"){
            if let url = URL(string: model.urlStr){
                cellImage.sd_setImage(with: url, completed: nil)
            }else{
                cellImage.image = nil
            }
            
        }else{
            cellImage.image = UIImage(named: model.urlStr)
        }
        
    }

}
