//
//  ExportDefault2ViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 13/11/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

class ExportDefault2ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
            imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)
            imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
            imageView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .vertical)
        }
    }
    @IBOutlet weak var tagImage1: UIImageView! {
        didSet {
            tagImage1.layer.masksToBounds = true
            tagImage1.layer.cornerRadius = 15
            tagImage1.layer.borderWidth = 2
            tagImage1.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagImage2: UIImageView! {
        didSet {
            tagImage2.layer.masksToBounds = true
            tagImage2.layer.cornerRadius = 15
            tagImage2.layer.borderWidth = 2
            tagImage2.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var tagLabel2: UILabel!
    
    @IBOutlet weak var captureView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
