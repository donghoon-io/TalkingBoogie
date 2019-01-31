//
//  InnerSorted1ViewCell.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 06/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import AVFoundation

class InnerSorted1ViewCell: UICollectionViewCell {
    
    var timer = Timer()
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = 15
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            let sortedTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sortedImageTapped(tapGestureRecognizer:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(sortedTapGestureRecognizer)
        }
    }
    @IBOutlet weak var imageLabel: UILabel!
    
    @objc func sortedImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var charCount = 0
        
        if Array(self.imageLabel.text!).count != 1 {
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(self.imageLabel.text!).count {
                    let range = (self.imageLabel.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: self.imageLabel.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    self.imageLabel.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    self.imageLabel.textColor = .black
                    self.imageView.layer.borderWidth = 2
                    self.imageView.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        } else {
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    self.imageLabel.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    self.imageLabel.textColor = .black
                    self.imageView.layer.borderWidth = 2
                    self.imageView.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        }
        
        let synthesizer = AVSpeechSynthesizer()
        
        let utterance = AVSpeechUtterance(string: self.imageLabel.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synthesizer.speak(utterance)
    }
}
