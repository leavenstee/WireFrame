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
    @IBOutlet private weak var imageOne: UIImageView!
    @IBOutlet private weak var imageTwo: UIImageView!
    @IBOutlet private weak var imageThree: UIImageView!
    
    /** Headers */
    @IBOutlet private weak var headerOne: UILabel!
    @IBOutlet private weak var headerTwo: UILabel!
    @IBOutlet private weak var headerThree: UILabel!
    
    /** Details */
    @IBOutlet private weak var detailOne: UILabel!
    @IBOutlet private weak var detailTwo: UILabel!
    @IBOutlet private weak var detailThree: UILabel!
    
    /** Buttons */
    @IBOutlet weak var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // New Thing One
        imageOne.image = #imageLiteral(resourceName: "drawing")
        imageOne.tintColor = .white
        headerOne.text = "Design"
        detailOne.text = "Import a previous screenshot and sketch on top of it!"
        
        // New Thing Two
        imageTwo.image = #imageLiteral(resourceName: "save-file-option")
        imageTwo.tintColor = .white
        headerTwo.text = "Save"
        detailTwo.text = "Hard press and save your creations to be accessed at a later time"
        
        // New Thing Three
        imageThree.image = #imageLiteral(resourceName: "paper-plane")
        imageThree.tintColor = .white
        headerThree.text = "Share"
        detailThree.text = "Simply select a design, hard press and share to show anyone your new idea"
    }

    @IBAction func continueButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
