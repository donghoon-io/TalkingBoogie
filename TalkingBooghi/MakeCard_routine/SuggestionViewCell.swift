//
//  SuggestionViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 05/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class SuggestionViewCell: UICollectionViewCell {
    @IBOutlet weak var suggestionImage: UIImageView! {
        didSet {
            suggestionImage.layer.cornerRadius = 10
            suggestionImage.layer.borderColor = UIColor.lightGray.cgColor
            suggestionImage.layer.borderWidth = 2
        }
    }
}
