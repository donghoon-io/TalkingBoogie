//
//  RoutineViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 03/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

protocol RoutineCellDelegate: class {
    func delete(cell: RoutineViewCell)
}

class RoutineViewCell: UICollectionViewCell {
    
    var delegate: RoutineCellDelegate?
    
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
