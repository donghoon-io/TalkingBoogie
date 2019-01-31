//
//  ItemsViewCell.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 21..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import UIKit

class ItemsViewCell: UICollectionViewCell {
    @IBOutlet weak var selectedView: UIImageView! {
        didSet {
            selectedView.isHidden = true
        }
    }
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel! {
        didSet {
           imageNameLabel.isHidden = true
        }
    }

    /*override func prepareForReuse() {
        super.prepareForReuse()
        isPicked = false
        isEditing = false
        selectedView.isHidden = true
    }*/
}
