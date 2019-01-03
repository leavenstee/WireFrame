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
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(withItem item: DrawingBoard) {
        guard let image = item.image else {
            fatalError("Image Not Set")
        }
        
        guard let title = item.title else {
            fatalError("Title Not Set")
        }
        
        imageView.image = image
        label.text = title
    }
}
