//
//  ViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView : UICollectionView!
    var items : [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      //  let drawVC = DrawViewController()
      //  self.navigationController?.pushViewController(drawVC, animated: true)
        
        
    }
    
    func setupView() {
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.view.backgroundColor = .blue
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
   
}

