//
//  DrawCollectionViewCell.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class DrawCollectionViewCell: UICollectionViewCell {
    var imageView : UIImageView!
    var title : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-50))
        self.addSubview(imageView)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // Override reuses issue 
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView = nil;
        title = nil;
    }
    
    // Set Image Method with error Check
    func setImage(image:UIImage) {
        if (self.imageView != nil) {
            self.imageView.image = image
        }
    }
    

    
}
