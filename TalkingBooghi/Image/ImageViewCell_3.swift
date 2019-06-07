//
//  ImageViewCell_3.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 01/09/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit
import AVFoundation

class ImageViewCell_3: UICollectionViewCell {
    
    var timer = Timer()
    
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
            let symbol1TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(symbol1ImageTapped(tapGestureRecognizer:)))
            tagImage1.isUserInteractionEnabled = true
            tagImage1.addGestureRecognizer(symbol1TapGestureRecognizer)
            tagImage1.layer.borderWidth = 2
            tagImage1.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var tagLabel1: UILabel!
    @IBOutlet weak var tagImage2: UIImageView! {
        didSet {
            tagImage2.layer.masksToBounds = true
            tagImage2.layer.cornerRadius = 15
            let symbol2TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(symbol2ImageTapped(tapGestureRecognizer:)))
            tagImage2.isUserInteractionEnabled = true
            tagImage2.addGestureRecognizer(symbol2TapGestureRecognizer)
            tagImage2.layer.borderWidth = 2
            tagImage2.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var tagLabel2: UILabel!
    @IBOutlet weak var tagImage3: UIImageView! {
        didSet {
            tagImage3.layer.masksToBounds = true
            tagImage3.layer.cornerRadius = 15
            let symbol3TapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(symbol3ImageTapped(tapGestureRecognizer:)))
            tagImage3.isUserInteractionEnabled = true
            tagImage3.addGestureRecognizer(symbol3TapGestureRecognizer)
            tagImage3.layer.borderWidth = 2
            tagImage3.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var tagLabel3: UILabel!
    @objc func symbol1ImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var charCount = 0
        
        if Array(self.tagLabel1.text!).count != 1 {
            tagImage1.layer.borderWidth = 3
            tagImage1.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(self.tagLabel1.text!).count {
                    let range = (self.tagLabel1.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: self.tagLabel1.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    self.tagLabel1.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    
                    self.tagLabel1.textColor = .black
                    self.tagImage1.layer.borderWidth = 2
                    self.tagImage1.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        } else {
            tagImage1.layer.borderWidth = 3
            tagImage1.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    self.tagLabel1.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    
                    self.tagLabel1.textColor = .black
                    self.tagImage1.layer.borderWidth = 2
                    self.tagImage1.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        }
        
        let synthesizer = AVSpeechSynthesizer()
        
        let utterance = AVSpeechUtterance(string: self.tagLabel1.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synthesizer.speak(utterance)
    }
    @objc func symbol2ImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var charCount = 0
        
        if Array(self.tagLabel2.text!).count != 1 {
            tagImage2.layer.borderWidth = 3
            tagImage2.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(self.tagLabel2.text!).count {
                    let range = (self.tagLabel2.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: self.tagLabel2.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    self.tagLabel2.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    
                    self.tagLabel2.textColor = .black
                    self.tagImage2.layer.borderWidth = 2
                    self.tagImage2.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        } else {
            tagImage2.layer.borderWidth = 3
            tagImage2.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    self.tagLabel2.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    
                    self.tagLabel2.textColor = .black
                    self.tagImage2.layer.borderWidth = 2
                    self.tagImage2.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        }
        
        let synthesizer = AVSpeechSynthesizer()
        
        let utterance = AVSpeechUtterance(string: self.tagLabel2.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synthesizer.speak(utterance)
    }
    @objc func symbol3ImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        var charCount = 0
        
        if Array(self.tagLabel3.text!).count != 1 {
            tagImage3.layer.borderWidth = 3
            tagImage3.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount < Array(self.tagLabel3.text!).count {
                    let range = (self.tagLabel3.text! as NSString).rangeOfComposedCharacterSequence(at: charCount)
                    let attributedText = NSMutableAttributedString.init(string: self.tagLabel3.text!)
                    attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1), range: range)
                    self.tagLabel3.attributedText = attributedText
                    charCount += 1
                } else {
                    timer.invalidate()
                    
                    self.tagLabel3.textColor = .black
                    self.tagImage3.layer.borderWidth = 2
                    self.tagImage3.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        } else {
            tagImage3.layer.borderWidth = 3
            tagImage3.layer.borderColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1).cgColor
            timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { timer in
                if charCount == 0 {
                    self.tagLabel3.textColor = UIColor(red: 90/255.0, green: 181/255.0, blue: 234/255.0, alpha: 1)
                    charCount += 1
                } else {
                    timer.invalidate()
                    
                    self.tagLabel3.textColor = .black
                    self.tagImage3.layer.borderWidth = 2
                    self.tagImage3.layer.borderColor = UIColor.lightGray.cgColor
                }
            })
        }
        
        let synthesizer = AVSpeechSynthesizer()
        
        let utterance = AVSpeechUtterance(string: self.tagLabel3.text!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        utterance.rate = speechSpeed
        
        synthesizer.speak(utterance)
    }
}
