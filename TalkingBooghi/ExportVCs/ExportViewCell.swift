//
//  ExportViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 14/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ExportViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 15
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imageLabel: UILabel!
    
}
