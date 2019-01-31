//
//  InitScrollViewController.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 10/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import Localize_Swift

class InitScrollViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton! {
        didSet {
            startButton.layer.cornerRadius = startButton.bounds.height/2
            startButton.alpha = 0
        }
    }
    @IBAction func startButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = CGRect(x:0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        
        let imgHeight: CGFloat = view.bounds.height * 0.75
        let startX = view.center.x - imgHeight/4
        let startY: CGFloat = 30
        let imgOne = UIImageView(frame: CGRect(x: startX, y: startY, width: imgHeight/2, height: imgHeight))
        imgOne.image = UIImage(named: "firstIntro".localized())
        imgOne.contentMode = .scaleAspectFill
        imgOne.clipsToBounds = true
        let imgTwo = UIImageView(frame: CGRect(x: startX + scrollViewWidth, y: startY, width: imgHeight/2, height: imgHeight))
        imgTwo.image = UIImage(named: "secondIntro".localized())
        imgTwo.contentMode = .scaleAspectFill
        imgTwo.clipsToBounds = true
        let imgThree = UIImageView(frame: CGRect(x: startX + scrollViewWidth*2, y: startY, width: imgHeight/2, height: imgHeight))
        imgThree.image = UIImage(named: "thirdIntro".localized())
        imgThree.contentMode = .scaleAspectFill
        imgThree.clipsToBounds = true
        
        self.scrollView.addSubview(imgOne)
        self.scrollView.addSubview(imgTwo)
        self.scrollView.addSubview(imgThree)
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 3, height:self.scrollView.frame.height)
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0

        // Do any additional setup after loading the view.
    }
}

private typealias ScrollView = InitScrollViewController

extension ScrollView {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
        // Change the text accordingly
        if Int(currentPage) == 2 {
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.startButton.alpha = 1.0
            })
        }
    }
}
