//
//  DrawViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 7/29/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class DrawViewController: UIViewController {
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var tempImageView : UIImageView!
    var mainImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //  let drawVC = DrawViewController()
        //  self.navigationController?.pushViewController(drawVC, animated: true)
        
        self.tempImageView = UIImageView(frame: self.view.frame)
        self.mainImageView = UIImageView(frame: self.view.frame)
        
        self.view.addSubview(mainImageView)
        self.view.addSubview(tempImageView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // self.view.backgroundColor = .blue
    }
    
    // Override Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    
    
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        tempImageView.image?.draw(in:CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        // CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        //CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        context?.setLineCap(CGLineCap.round)
        //CGContextSetLineCap(context, kCGLineCapRound)
        context?.setLineWidth(brushWidth)
        //CGContextSetLineWidth(context, brushWidth)
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        //CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        //CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        // 4
        context!.strokePath()
        //context.setstrokepath
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
    }


}
