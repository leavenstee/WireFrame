//
//  DrawCollectionViewCell.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class DrawCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tintLayer: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // Set Image Method with error Check
    public func setImage(image:UIImage) {
        if (self.imageView != nil) {
            self.imageView.image = image
        }
    }
    
    public func setCornerRadius(_ num: Float) {
        self.tintLayer.layer.cornerRadius = 10;
        self.imageView.layer.cornerRadius = 10;
        self.contentView.layer.cornerRadius = 10;
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
    }
    
}
