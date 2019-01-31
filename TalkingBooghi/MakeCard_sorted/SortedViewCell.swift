//
//  SortedViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 05/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

protocol SortedCellDelegate: class {
    func delete(cell: SortedViewCell)
}

class SortedViewCell: UICollectionViewCell {
    var delegate: SortedCellDelegate?
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        delegate?.delete(cell: self)
    }
    
    @IBOutlet weak var selectImageView: UIImageView! {
        didSet {
            selectImageView.layer.masksToBounds = true
            selectImageView.layer.cornerRadius = 15
        }
    }
    
    @IBOutlet weak var selectImageLabel: UILabel!
}
