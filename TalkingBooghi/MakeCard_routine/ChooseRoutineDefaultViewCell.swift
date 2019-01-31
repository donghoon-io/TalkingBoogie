//
//  ChooseRoutineDefaultViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 03/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ChooseRoutineDefaultViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addingImage: UIImageView! {
        didSet {
            addingImage.layer.cornerRadius = 5
        }
    }
}
