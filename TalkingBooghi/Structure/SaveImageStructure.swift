//
//  SaveFile.swift
//  saveImage
//
//  Created by Donghoon Shin on 2018. 7. 28..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import Foundation
import UIKit

func saveDocumentImage(img: UIImage, imgPath: String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgPath)
    let imageData = UIImageJPEGRepresentation(img, 1)
    fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
}

func deleteDocumentImage(imgPath: String) {
    let fileManager = FileManager.default
    let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imgPath)
    if fileManager.fileExists(atPath: paths) {
        do {
            try fileManager.removeItem(atPath: paths)
        } catch {
            print(error)
        }
    }
}

func deleteEveryInDirectory() {
    let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    do {
        let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
        for fileURL in fileURLs {
            try FileManager.default.removeItem(at: fileURL)
        }
    } catch  {
        print(error)
    }
}

func importEveryInDirectory() -> [String: Data] {
    var dataArray: [String: Data] = [:]
    do {
        let paths = try FileManager.default.contentsOfDirectory(atPath: getDirectoryPath())
        for item in paths {
            let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(item)
            dataArray.merge([item: FileManager.default.contents(atPath: imagePath)!]) { (_, new) in new }
        }
        return dataArray
    } catch {
        print("error occured")
        return [:]
    }
}

func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
}

func getDocumentImage(imgPath: String) -> UIImage? {
    let fileManager = FileManager.default
    let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(imgPath)
    if fileManager.fileExists(atPath: imagePath) {
        return UIImage(contentsOfFile: imagePath) ?? nil
    }
    return nil
}

func getTodayString() -> String{
    let date = Date()
    let calender = Calendar.current
    let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
    
    let year = components.year
    let month = components.month
    let day = components.day
    let hour = components.hour
    let minute = components.minute
    let second = components.second
    
    let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + "_" + String(hour!)  + "-" + String(minute!) + "-" +  String(second!)
    
    return today_string
}

func loadImage(named: String) -> UIImage {
    if let imgTemp = UIImage(named: named) {
        return imgTemp
    } else if getDocumentImage(imgPath: named) != nil {
        return getDocumentImage(imgPath: named)!
    } else {
        return UIImage(named: "defaultImage")!
    }
}

func loadMainImage(named: String) -> UIImage? {
    if let img = getDocumentImage(imgPath: named) {
        return img
    }
    return nil
}
