//
//  MoveViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 24/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class MoveViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var howManyLabel: UILabel!
    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var shadowView: UIVisualEffectView! {
        didSet {
            shadowView.layer.cornerRadius = 5
            shadowView.clipsToBounds = true
        }
    }
}
