//
//  ViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit
import CoreData

public let navBarHeight : Float =  60.0
public let statusBarHeight : Float =  30.0

class MainViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    private var items : [DrawingBoard]!
    
    // Story Board Hook up
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadData()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func setupView() {
        self.collectionView.register(DrawCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = true
        self.collectionView.bounces = true;
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let db = DrawingBoard()
        
        self.items.append(db)
        self.collectionView.reloadData()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.collectionView.reloadData()
    }

    // Load Data Method
    func loadData() {
        self.items = CoreDataManager.sharedManager.getDataFromTable("Boards")
    }
}


extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "drawCell", for: indexPath) as! DrawCollectionViewCell
        
        if (self.items[indexPath.row].image != nil) {
            cell.setImage(image: self.items[indexPath.row].image)
        }
        
        cell.label.text = self.items[indexPath.row].title ?? ""
        cell.setCornerRadius(10.0)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drawVC = DrawViewController(boardObject: self.items[indexPath.row])
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        self.view.window?.layer.add(transition, forKey: "openDrawVC")
        
        navigationController?.pushViewController(drawVC, animated: true)
    }
    
    
}

