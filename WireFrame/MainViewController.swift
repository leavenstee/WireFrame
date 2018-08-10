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

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    
    private var items : [DrawingBoard]!
    
    // Story Board Hook up
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadData()
        self.setupView()
    }
    
    
    func setupView() {
        self.view.backgroundColor = .white
        
        self.navigationController?.addChild(self)
        
   
        
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: CGFloat(statusBarHeight), width: screenSize.width, height: CGFloat(navBarHeight)))
//        navBar.prefersLargeTitles = true
//        let navItem = UINavigationItem(title: "Framer")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(add))
//        navItem.rightBarButtonItem = doneItem
//        navBar.setItems([navItem], animated: false)
//        self.view.addSubview(navBar)
        
       
        self.collectionView.register(DrawCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isScrollEnabled = true
        self.collectionView.bounces = true;
        self.collectionView.backgroundColor = .clear
        
 
       
    }

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        let db = DrawingBoard()
        
        self.items.append(db)
        self.collectionView.reloadData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DrawCollectionViewCell
        
        if (self.items[indexPath.row].image != nil) {
            cell.setImage(image: self.items[indexPath.row].image)
            cell.backgroundColor = UIColor(red:0.97, green:0.78, blue:0.44, alpha:0.5)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width: 200, height: 50)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let drawVC = DrawViewController(boardObject: self.items[indexPath.row])
       
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        self.view.window?.layer .add(transition, forKey: "openDrawVC")
        
        self.present(drawVC, animated:false, completion:{
         
        })
    }
    
    
    
    // Load Data Method
    func loadData() {
        self.items = []
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Boards")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "id") as! UUID)
                
                let tempObject = DrawingBoard()
                tempObject.title = data.value(forKey: "title") as? String
                tempObject.date = data.value(forKey: "date") as? Date
                tempObject.id = data.value(forKey: "id") as? UUID
                tempObject.image = UIImage(data: (data.value(forKey: "image") as? Data)!)
                items.append(tempObject)
            }
        } catch {
            print("Failed")
        }
    }
    
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: p)
        
        if let index = indexPath {
            var cell = self.collectionView.cellForItem(at: index)
            // do stuff with your cell, for example print the indexPath
            print(index.row)
        } else {
            print("Could not find index path")
        }
    }
   
}

