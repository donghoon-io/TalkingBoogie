//
//  ExportRoutineViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 17/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ExportRoutineViewController: UIViewController {
    var images = [UIImage]()
    var imageNames = [String]()
    var titleText = String()
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.isHidden = false
        }
    }
    
    @IBOutlet weak var captureView: UIView!
    
    @IBOutlet weak var moreView: UIView! {
        didSet {
            moreView.isHidden = true
        }
    }
    
    @IBOutlet weak var imageView1: UIImageView! {
        didSet {
            imageView1.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLabel1: UILabel!
    
    @IBOutlet weak var imageView2: UIImageView! {
        didSet {
            imageView2.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLabel2: UILabel!
    
    @IBOutlet weak var imageView3: UIImageView! {
        didSet {
            imageView3.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        
    }
    
    func reloadView() {
        titleLabel.text = titleText
        switch imageNames.count {
        case 0:
            break
        case 1:
            imageView1.image = images[0]
            imageView1.layer.cornerRadius = 15
            imageView1.layer.borderColor = UIColor.lightGray.cgColor
            imageView1.layer.borderWidth = 2.0
            titleLabel1.text = imageNames[0]
        case 2:
            imageView1.image = images[0]
            imageView1.layer.cornerRadius = 15
            imageView1.layer.borderColor = UIColor.lightGray.cgColor
            imageView1.layer.borderWidth = 2.0
            titleLabel1.text = imageNames[0]
            imageView2.image = images[1]
            imageView2.layer.cornerRadius = 15
            imageView2.layer.borderColor = UIColor.lightGray.cgColor
            imageView2.layer.borderWidth = 2.0
            titleLabel2.text = imageNames[1]
        case 3:
            imageView1.image = images[0]
            imageView1.layer.cornerRadius = 15
            imageView1.layer.borderColor = UIColor.lightGray.cgColor
            imageView1.layer.borderWidth = 2.0
            titleLabel1.text = imageNames[0]
            imageView2.image = images[1]
            imageView2.layer.cornerRadius = 15
            imageView2.layer.borderColor = UIColor.lightGray.cgColor
            imageView2.layer.borderWidth = 2.0
            titleLabel2.text = imageNames[1]
            imageView3.image = images[2]
            imageView3.layer.cornerRadius = 15
            imageView3.layer.borderColor = UIColor.lightGray.cgColor
            imageView3.layer.borderWidth = 2.0
        default:
            imageView1.image = images[0]
            imageView1.layer.cornerRadius = 15
            imageView1.layer.borderColor = UIColor.lightGray.cgColor
            imageView1.layer.borderWidth = 2.0
            titleLabel1.text = imageNames[0]
            imageView2.image = images[1]
            imageView2.layer.cornerRadius = 15
            imageView2.layer.borderColor = UIColor.lightGray.cgColor
            imageView2.layer.borderWidth = 2.0
            titleLabel2.text = imageNames[1]
            imageView3.image = images[2]
            imageView3.layer.cornerRadius = 15
            imageView3.layer.borderColor = UIColor.lightGray.cgColor
            imageView3.layer.borderWidth = 2.0
            moreView.isHidden = false
        }
    }
}
