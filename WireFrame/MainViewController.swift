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
        
        // is first time on this version
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            let defaults = UserDefaults.standard
            if (version != defaults.string(forKey: "Version")){
                self.navigationController?.present((storyboard?.instantiateViewController(withIdentifier: "WhatsNewViewController"))!, animated: true, completion: {
                    defaults.set(version, forKey: "Version")
                })
            }
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let db = DrawingBoard()
        self.items.insert(db, at: 0)
        self.collectionView?.reloadData()
        let drawVC = DrawViewController(boardObject: self.items[0])
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: "openDrawVC")
        navigationController?.pushViewController(drawVC, animated: true)
    }
    @IBAction func infoButtonAction(_ sender: Any) {
        self.navigationController?.present((storyboard?.instantiateViewController(withIdentifier: "WhatsNewViewController"))!, animated: true, completion: nil)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        self.collectionView?.reloadData()
    }

    // Load Data Method
    func loadData() {
        self.items = CoreDataManager.sharedManager.getDataFromTable("Boards")
    }
}


extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.items.count == 0) {
            self.setEmptyMessage("No Wireframes Yet!\nPress New To Get Started")
        } else {
            self.restore()
        }
        
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
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: "openDrawVC")
        
        navigationController?.pushViewController(drawVC, animated: true)
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (self.collectionView?.bounds.size.width)!, height: (self.collectionView?.bounds.size.height)!))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Helvetica", size: 18)
        messageLabel.sizeToFit()
        
        self.collectionView?.backgroundView = messageLabel;
    }
    
    func restore() {
        self.collectionView?.backgroundView = nil
    }
    
    
}

