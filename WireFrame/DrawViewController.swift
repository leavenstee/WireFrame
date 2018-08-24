//
//  DrawViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    
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
    
    var board: DrawingBoard!
    var lastPoint = CGPoint.zero

    var state: ColorState!
    var colorNum: CGFloat = 0.0
    
    var brushWidth: CGFloat = 3.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var tempImageView : UIImageView!
    var mainImageView : UIImageView!
    var menuButton : UIButton!
    var menuAlertViewController: UIAlertController!
    
    init(boardObject: DrawingBoard) {
        super.init(nibName: nil, bundle: nil)
        self.board = boardObject
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func setupView(){
        self.view.backgroundColor = .white
        self.tempImageView = UIImageView(frame: self.view.frame)
        self.mainImageView = UIImageView(frame: self.view.frame)
        
        self.view.addSubview(mainImageView)
        self.view.addSubview(tempImageView)
        
        self.mainImageView.image = self.board.image
        
        self.state = .black
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motio
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.showMenu()
        }
    }
    
    
    func showMenu(){
        self.menuAlertViewController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
            self.board.image = self.mainImageView.image
            self.board.save()
            self.navigationController?.popViewController(animated: true)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.board.delete()
            self.navigationController?.popViewController(animated: true)
        }
        
        let share = UIAlertAction(title: "Share", style: .default) { (action) in
            self.showShareSheet()
        }
        
        // Pen Color Switch (Black == Write && White == Erase)
        var penColorSwap : UIAlertAction!
        switch self.state {
        case .black?:
                penColorSwap = UIAlertAction(title: "Erase", style: .default) { (action) in
                    self.colorNum = 1.0
                    self.brushWidth = 10.0
                    self.state = .white
                }
        case .white?:
                penColorSwap = UIAlertAction(title: "Draw", style: .default) { (action) in
                    self.colorNum = 0.0
                    self.brushWidth = 3.0
                    self.state = .black
                    
                }
        case .none:
            print("NONE")
        }
        
        let addNavBarLarge = UIAlertAction(title: "Insert Tab Bar", style: .default) { (action) in
            self.addTabBarWithType(.five)
        }
        

        self.menuAlertViewController.addAction(save)
        self.menuAlertViewController.addAction(delete)
        self.menuAlertViewController.addAction(share)
        self.menuAlertViewController.addAction(penColorSwap)
        self.menuAlertViewController.addAction(addNavBarLarge)
        present(self.menuAlertViewController, animated: true, completion: nil)
    }
    
    
    func showShareSheet() {
        if let shareImage = self.mainImageView.image {
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
        var size : CGFloat = 64.0
        if (type == .large){
            size = 88.0
        }
        let firstPoint = CGPoint(x: 0.0, y: size)
        let secondPoint = CGPoint(x: self.view.frame.width, y: size)
       
        self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
    }
   
    private func addTabBarWithType(_ type: TabBarType) {
        let tabBarHeightY = self.view.frame.height - 58
        
        var firstPoint = CGPoint(x: 0.0, y: tabBarHeightY)
        var secondPoint = CGPoint(x: self.view.frame.width, y: tabBarHeightY)
        
        self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        
        switch type {
        case .two: // 1 line
            firstPoint = CGPoint(x: self.view.center.x, y: tabBarHeightY)
            secondPoint = CGPoint(x: self.view.center.x, y: self.view.frame.height)
            
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        case .three: // 2 lines
            let thirdOfScreen = self.view.frame.width/3
            
            firstPoint = CGPoint(x: thirdOfScreen, y: tabBarHeightY)
            secondPoint = CGPoint(x: thirdOfScreen, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: thirdOfScreen*2, y: tabBarHeightY)
            secondPoint = CGPoint(x: thirdOfScreen*2, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        case .four: // 3 lines
            let fourthOfScreen = self.view.frame.width/4
            
            firstPoint = CGPoint(x: fourthOfScreen, y: tabBarHeightY)
            secondPoint = CGPoint(x: fourthOfScreen, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fourthOfScreen*2, y: tabBarHeightY)
            secondPoint = CGPoint(x: fourthOfScreen*2, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fourthOfScreen*3, y: tabBarHeightY)
            secondPoint = CGPoint(x: fourthOfScreen*3, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        case .five: // 4 lines
            let fifthOfScreen = self.view.frame.width/5
            
            firstPoint = CGPoint(x: fifthOfScreen, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fifthOfScreen*2, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen*2, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fifthOfScreen*3, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen*3, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
            
            firstPoint = CGPoint(x: fifthOfScreen*4, y: tabBarHeightY)
            secondPoint = CGPoint(x: fifthOfScreen*4, y: self.view.frame.height)
            self.drawLineFrom(fromPoint: firstPoint, toPoint: secondPoint)
        default:
            print("dab emoji")
        }
    }
}
