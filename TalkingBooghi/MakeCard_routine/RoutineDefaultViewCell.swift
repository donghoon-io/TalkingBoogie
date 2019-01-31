//
//  RoutineDefaultViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 19/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class RoutineDefaultViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var imageLabel: UILabel!
}
