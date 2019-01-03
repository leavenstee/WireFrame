//
//  ViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    public var viewModel: MainViewModel?
   
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let navigationController = navigationController else {
            fatalError("Navigation Controller Not Set")
        }
        
        guard let window = view.window else {
            fatalError("Window Error")
        }
        
        guard let viewModel = viewModel else {
            fatalError("View Model Not Set")
        }
        
        guard let storyboard = storyboard else {
            fatalError("Story Board Not Set")
        }
        
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.view.backgroundColor = .lightGray

        // Custom Transition
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        window.layer.add(transition, forKey: "openDrawVC")
        
        viewModel.loadData { (_) in
            guard let collectionView = collectionView else {
                fatalError("CollectionView Not Set")
            }
            collectionView.reloadData()
        }
        
        // is first time on this version
        if viewModel.isNewVersion() {
            navigationController.present((storyboard.instantiateViewController(withIdentifier: whatsNewVCConst)), animated: true, completion: nil)
        }
    }
    

    @IBAction func addItem(_ sender: UIBarButtonItem) {
        guard let viewModel = viewModel else {
            fatalError("View Model Not Set")
        }
        viewModel.createNewDrawingBoard(completion: { (drawVC) in
            guard let navigationController = navigationController else {
                fatalError("Navigation Controller Not Set")
            }
            navigationController.pushViewController(drawVC, animated: true)
        })
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        guard let navigationController = navigationController else {
            fatalError("Navigation Controller Not Set")
        }
        guard let storyboard = storyboard else {
            fatalError("Storyboard Not Set")
        }
        navigationController.present((storyboard.instantiateViewController(withIdentifier: whatsNewVCConst)), animated: true, completion: nil)
    }
}


extension MainViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            fatalError("Viewmodel Not Set")
        }
        
        if (viewModel.numberOfItems() == 0) {
            self.setEmptyMessage("No Wireframes Yet!\nPress New To Get Started")
        } else {
            self.restore()
        }
        
        return viewModel.numberOfItems()
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            fatalError("ViewModel Not Set")
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: drawingCellConst, for: indexPath) as! DrawCollectionViewCell
        let item = viewModel.itemAtIndex(indexPath)
        cell.configureCell(withItem: item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            fatalError("ViewModel Not Set")
        }
        guard let navigationController = navigationController else {
            fatalError("NavigationController Not Set")
        }
        
        let drawVC = DrawViewController(boardObject: viewModel.itemAtIndex(indexPath))
        navigationController.pushViewController(drawVC, animated: true)
    }
    
    func setEmptyMessage(_ message: String) {
        guard let collectionView = collectionView else {
            fatalError("CollectionView Not Set")
        }
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (collectionView.bounds.size.width), height: (collectionView.bounds.size.height)))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Futura", size: 18)
        messageLabel.sizeToFit()
        collectionView.backgroundView = messageLabel;
    }
    
    func restore() {
        guard let collectionView = collectionView else {
            fatalError("Collection View Not Set")
        }
        
        collectionView.backgroundView = nil
    }
    
    
}

