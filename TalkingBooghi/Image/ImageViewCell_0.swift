//
//  ImageViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 2018. 8. 8..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

class ImageViewCell_0: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.masksToBounds = true
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
            imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
            imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .vertical)
        }
    }
}
