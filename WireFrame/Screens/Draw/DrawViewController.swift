//
//  DrawViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit
import Photos

class DrawViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    // MARK: Enums
    enum ColorState {
        case black
        case white
    }
    
    enum NavBarType {
        case iPhoneXRegular
        case iPhoneXLarge
        case regular
        case large
    }
    
    enum TabBarType {
        case two
        case three
        case four
        case five
    }
    
    // MARK: Public Vars
    public var board: DrawingBoard!
    
    // MARK: Private Vars
    private var lastPoint = CGPoint.zero
    private var state: ColorState = .black
    private var colorNum: CGFloat = 0.0
    private var brushWidth: CGFloat = 3.0
    private var opacity: CGFloat = 1.0
    private var swiped = false
    private var tempImageView : UIImageView!
    private var mainImageView : UIImageView!
    private var menuButton : UIButton!
    private var menuAlertViewController: UIAlertController!
    
    init(boardObject: DrawingBoard) {
        super.init(nibName: nil, bundle: nil)
        board = boardObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let navigationController = navigationController else {
            fatalError("Navigation Controller Not Set")
        }
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func setupView(){
        view.backgroundColor = .white

        tempImageView = UIImageView(frame: self.view.frame)
        mainImageView = UIImageView(frame: self.view.frame)
        
        view.addSubview(mainImageView)
        view.addSubview(tempImageView)
        
        mainImageView.image = board.image
     
        // Long Press Gestuere
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.view.addGestureRecognizer(lpgr)

    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motio
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (done) in
            self.showMenu()
        }

    }
    
    
    func showMenu(){
        self.menuAlertViewController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Close", style: .cancel) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }) { (done) in
                self?.write()
            }
        }
        
        // Pen Color Switch (Black == Write && White == Erase)
        var penColorSwap : UIAlertAction!

        switch state {
        case .black:
            penColorSwap = UIAlertAction(title: "Erase", style: .default) { [weak self]  (action) in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.view.transform = .init(translationX: 0, y: 0)
                }) { (done) in
                    self?.colorNum = 1.0
                    self?.brushWidth = 10.0
                    self?.state = .white
                }
            }
        case .white:
            penColorSwap = UIAlertAction(title: "Draw", style: .default) { [weak self] (action) in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.view.transform = .init(translationX: 0, y: 0)
                }) { (done) in
                    self?.colorNum = 0.0
                    self?.brushWidth = 3.0
                    self?.state = .black
                }
            }
        }
        
        let save = UIAlertAction(title: "Save", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.board.image = self?.mainImageView.image
                self?.board.save()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        let delete = UIAlertAction(title: "Delete", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.board.delete()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        let share = UIAlertAction(title: "Share", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.showShareSheet()
            }
        }
        
        let showStyleSheet = UIAlertAction(title: "Style Sheet", style: .default) { [weak self]  (action) in
            self?.showStyleSheet()
        }
    
        self.menuAlertViewController.addAction(penColorSwap)
        self.menuAlertViewController.addAction(showStyleSheet)
        self.menuAlertViewController.addAction(save)
        self.menuAlertViewController.addAction(delete)
        self.menuAlertViewController.addAction(share)
        self.menuAlertViewController.addAction(cancel)
        
        // iPad Stuff so it doesnt crash
        self.menuAlertViewController.popoverPresentationController?.sourceView = self.view
        self.menuAlertViewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        present(menuAlertViewController, animated: true, completion: nil)
    }
   
    
    func showStyleSheet(){
        self.menuAlertViewController = UIAlertController(title: "Style Sheet", message: nil, preferredStyle: .alert)
        
        let tabBarTwo = UIAlertAction(title: "Insert 2 Tabbed Bar", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.addTabBarWithType(.two)
            }
        }
        let tabBarThree = UIAlertAction(title: "Insert 3 Tabbed Bar", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.addTabBarWithType(.three)
            }
        }
        let tabBarFour = UIAlertAction(title: "Insert 4 Tabbed Bar", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.addTabBarWithType(.four)
            }
        }
        let tabBarFive = UIAlertAction(title: "Insert 5 Tabbed Bar", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.addTabBarWithType(.five)
            }
        }
        
        let navBar = UIAlertAction(title: "Navigation Bar", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.addNavigationBarWithType(.regular)
            }
        }
        let navBarLarge = UIAlertAction(title: "Large Navigation Bar", style: .default) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                self?.addNavigationBarWithType(.large)
            }
        }
        
        let cancel = UIAlertAction(title: "Close", style: .cancel) { [weak self]  (action) in
            UIView.animate(withDuration: 0.1, animations: {
                self?.view.transform = .init(translationX: 0, y: 0)
            }) { (done) in
                
            }
        }
        
        menuAlertViewController.addAction(navBar)
        menuAlertViewController.addAction(navBarLarge)
        menuAlertViewController.addAction(tabBarTwo)
        menuAlertViewController.addAction(tabBarThree)
        menuAlertViewController.addAction(tabBarFour)
        menuAlertViewController.addAction(tabBarFive)
        menuAlertViewController.addAction(cancel)
        
        // iPad Stuff so it doesnt crash
        menuAlertViewController.popoverPresentationController?.sourceView = view
        menuAlertViewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100)
       
        present(menuAlertViewController, animated: true, completion: nil)
    }
    
    
    
    func showShareSheet() {
        if let shareImage = mainImageView.image {
            let activityViewController = UIActivityViewController(activityItems: [shareImage], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        } else {
            print("could not retrieve image")
        }
    }
}


/**
 Drawing Ability
 */

extension DrawViewController {
    // Override Touches
    override internal func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override internal func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    override internal func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        
        self.write()
    }
    
    private func write() {
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: 1.0)
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempImageView.image = nil
    }
    
    
    // Drawing
   private func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in:CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // 3
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(red: self.colorNum, green: self.colorNum, blue: self.colorNum, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        // 4
        context!.strokePath()
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    private func addNavigationBarWithType(_ type: NavBarType) {
        if state == .white {
            colorNum = 0.0
            brushWidth = 3.0
            state = .black
        }
        
        var size : CGFloat = 64.0
        if (type == .large){
            size = 88.0
        }
        
        if(UIDevice.current.screenType == .iPhoneX) {
            size += 50
        }
        
        let firstPoint = CGPoint(x: 0.0, y: size)
        let secondPoint = CGPoint(x: self.view.frame.width, y: size)
       
        drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        write()
    }
   
    private func addTabBarWithType(_ type: TabBarType) {
        if state == .white {
            colorNum = 0.0
            brushWidth = 3.0
            state = .black
            
        }
        
        var screenHeight = view.frame.height
        if(UIDevice.current.screenType == .iPhoneX) {
            screenHeight = screenHeight - 50
        }
        let tabBarHeightY = screenHeight - 58
        var firstPoint = CGPoint(x: 0.0, y: tabBarHeightY)
        var secondPoint = CGPoint(x: view.frame.width, y: tabBarHeightY)
        
        self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        
        switch type {
        case .two: // 1 line
            firstPoint = CGPoint(x: view.center.x, y: tabBarHeightY)
            secondPoint = CGPoint(x: view.center.x, y: screenHeight)
            
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        case .three: // 2 lines
            let thirdOfScreen = view.frame.width/3
            
            firstPoint = CGPoint(x: thirdOfScreen, y: tabBarHeightY)
            secondPoint = CGPoint(x: thirdOfScreen, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: thirdOfScreen*2, y: tabBarHeightY)
            secondPoint = CGPoint(x: thirdOfScreen*2, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        case .four: // 3 lines
            let fourthOfScreen = view.frame.width/4
            
            firstPoint = CGPoint(x: fourthOfScreen, y: tabBarHeightY)
            secondPoint = CGPoint(x: fourthOfScreen, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fourthOfScreen*2, y: tabBarHeightY)
            secondPoint = CGPoint(x: fourthOfScreen*2, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fourthOfScreen*3, y: tabBarHeightY)
            secondPoint = CGPoint(x: fourthOfScreen*3, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        case .five: // 4 lines
            let fifthOfScreen = view.frame.width/5
            
            firstPoint = CGPoint(x: fifthOfScreen, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fifthOfScreen*2, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen*2, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fifthOfScreen*3, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen*3, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fifthOfScreen*4, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen*4, y: screenHeight)
            drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        }
        
        write()
    }
}
