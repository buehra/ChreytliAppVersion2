//
//  CustomCellController.swift
//  ChreytliV2
//
//  Created by Raphael Bühlmann on 04.02.16.
//  Copyright © 2016 ChreytliGaming. All rights reserved.
//

import UIKit

class CustomCellView: UICollectionViewCell {

    @IBOutlet weak var SubmitImage: UIImageView!
    @IBOutlet weak var DienstText: UITextView!
    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var ScoreBtn: UIButton!
    
    var index : Int = 0
    
    @IBAction func pressedFav(sender: AnyObject) {
        if chreytliAPI.sharedInstance.isLoggedin{
            
            chreytliAPI.sharedInstance.favoritSubmit(index)
            
        }
    }
}

