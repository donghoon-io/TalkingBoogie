 //
//  CardSelectionViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 14/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
 
protocol goToMakeCard {
    func goMake(titleName: String, type: String)
}
 
 class CardSelectionViewController: UIViewController {
    
    var whatIsTitleText: String?
    
    var makeDelegate: goToMakeCard!
    
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var selectView: UIView! {
        didSet {
            selectView.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var defaultButton1: UIButton! {
        didSet {
            buttonCustomize(input: defaultButton1)
        }
    }
    @IBOutlet weak var defaultButton2: UIButton! {
        didSet {
            buttonCustomize(input: defaultButton2)
        }
    }
    @IBOutlet weak var defaultButton3: UIButton! {
        didSet {
            buttonCustomize(input: defaultButton3)
        }
    }
    
    @IBAction func button1Clicked(_ sender: UIButton) {
        defaultButton1.setImage(UIImage(named: "highlited1"), for: .normal)
        defaultButton2.setImage(UIImage(named: "default2"), for: .normal)
        defaultButton3.setImage(UIImage(named: "default3"), for: .normal)
        self.dismiss(animated: true, completion: nil)
        makeDelegate.goMake(titleName: whatIsTitleText!, type: "default")
    }
    @IBAction func button2Clicked(_ sender: UIButton) {
        defaultButton1.setImage(UIImage(named: "default1"), for: .normal)
        defaultButton2.setImage(UIImage(named: "highlited2"), for: .normal)
        defaultButton3.setImage(UIImage(named: "default3"), for: .normal)
        self.dismiss(animated: true, completion: nil)
        makeDelegate.goMake(titleName: whatIsTitleText!, type: "routine")
    }
    @IBAction func button3Clicked(_ sender: UIButton) {
        defaultButton1.setImage(UIImage(named: "default1"), for: .normal)
        defaultButton2.setImage(UIImage(named: "default2"), for: .normal)
        defaultButton3.setImage(UIImage(named: "highlited3"), for: .normal)
        self.dismiss(animated: true, completion: nil)
        makeDelegate.goMake(titleName: whatIsTitleText!, type: "sorted")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    func buttonCustomize(input: UIButton) {
        input.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        input.layer.shadowOffset = CGSize(width:2.0, height: 2.0)
        input.layer.shadowRadius = 2.0
        input.layer.shadowOpacity = 0.5
    }
}
