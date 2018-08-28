//
//  WhatsNewViewController.swift
//  WireFrame
//
//  Created by Steven Lee on 8/27/18.
//  Copyright © 2018 leavenstee. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController {

    /** Images */
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    
    /** Headers */
    @IBOutlet weak var headerOne: UILabel!
    @IBOutlet weak var headerTwo: UILabel!
    @IBOutlet weak var headerThree: UILabel!
    
    /** Details */
    @IBOutlet weak var detailOne: UILabel!
    @IBOutlet weak var detailTwo: UILabel!
    @IBOutlet weak var detailThree: UILabel!
    
    /** Buttons */
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // New Thing One
        self.imageOne.image = #imageLiteral(resourceName: "drawing")
        self.headerOne.text = "Design"
        self.detailOne.text = "Create quick and easy wire frames within seconds"
        
        // New Thing Two
        self.imageTwo.image = #imageLiteral(resourceName: "save-file-option")
        self.headerTwo.text = "Save"
        self.detailTwo.text = "Shake and save your creations to be accessed at a later time"
        
        // New Thing Three
        self.imageThree.image = #imageLiteral(resourceName: "paper-plane")
        self.headerThree.text = "Share"
        self.detailThree.text = "Simply select a design, shake and press share to show anyone to your new idea"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func continueButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
