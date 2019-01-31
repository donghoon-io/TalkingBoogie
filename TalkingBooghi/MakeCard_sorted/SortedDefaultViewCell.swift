//
//  SortedDefaultViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 19/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class SortedDefaultViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var imageLabel: UILabel!
}
