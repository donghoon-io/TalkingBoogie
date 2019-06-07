//
//  DataSavingStrucrute.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 23/08/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//
/*
import Foundation
import Firebase
import FirebaseDatabase

func saveImageSets(userid: String) {
    for (index, _) in imageSets.enumerated() {
        imageSets[index].saveToFirebase(userid: userid)
    }
}

extension ImageSet {
    func saveToFirebase(userid: String) -> Void {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(userid)/\(self.imagePath)").setValue(["imageName": self.imageName, "imagePath": self.imagePath, "category": self.category, "cardType": self.cardType])
        
        for (index, _) in self.tagName.enumerated() {
            let tagName: String = "tagName" + String(index)
            let tagPath: String = "tagPath" + String(index)
            ref.child("users/\(userid)/\(self.imagePath)/tagName/\(tagName)").setValue(self.tagName[index])
            ref.child("users/\(userid)/\(self.imagePath)/tagPath/\(tagPath)").setValue(self.tagPath[index])
        }
    }
}

func saveImagesToFirebase(userid: String) {
    for (index, _) in imageSets.enumerated() {
        imageSets[index].saveToFirebase(userid: userid)
    }
    let ref = Storage.storage().reference().child("users").child(userid)
    Database.database().reference().child("users/\(userid)/imagePathLists").removeValue()
    for index in importEveryInDirectory().keys {
        if index != ".DS_Store" {
            ref.child(index).putData(importEveryInDirectory()[index]!, metadata: nil) { (metadata, error) in
                ref.child(index).downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    print(downloadURL.absoluteString)
                    Database.database().reference().child("users/\(userid)/imagePathLists").child(index).setValue(downloadURL.absoluteString)
                    
                    return
                })
            }
        }
    }
}

func loadURLsToBeDownloaded(userid: String, completion: @escaping([String]) -> Void) {
    var URLs: [String] = []
    let ref = Database.database().reference().child("users").child(userid).child("imagePathLists")
    ref.observeSingleEvent(of: .value) { snapshot in
        for item in snapshot.children {
            let temp = item as! DataSnapshot
            URLs.append(temp.value as! String)
        }
        completion(URLs)
    }
}

func loadImagesFromFirebase(userid: String, downloadListURL: [String]) {
    for item in downloadListURL {
        let storageRef = Storage.storage().reference(forURL: item)
        let fileManager = FileManager.default
        storageRef.getData(maxSize: 1024*1024*1024) { (data, error) in
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(storageRef.name)
            fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
        }
    }
}

func loadImageSets(userid: String) -> Void {
    var imgSet = [ImageSet]()
    let ref = Database.database().reference().child("users").child(userid)
    ref.observeSingleEvent(of: .value) { snapshot in
        for item in snapshot.children.allObjects as! [DataSnapshot] {
            if item.key != "imagePathLists" {
                var imgName = String()
                var imgPath = String()
                var tagNameArray = [String]()
                var tagPathArray = [String]()
                var category = String()
                
                imgName = item.childSnapshot(forPath: "imageName").value as! String
                imgPath = item.childSnapshot(forPath: "imagePath").value as! String
                category = item.childSnapshot(forPath: "category").value as! String
                
                for tagName in item.childSnapshot(forPath: "tagName").children.allObjects as! [DataSnapshot] {
                    tagNameArray.append(tagName.value as! String)
                }
                
                for tagPath in item.childSnapshot(forPath: "tagPath").children.allObjects as! [DataSnapshot] {
                    tagPathArray.append(tagPath.value as! String)
                }
                
                let tempImgSet = ImageSet(category: category, imageName: imgName, imagePath: imgPath, tagName: tagNameArray, tagPath: tagPathArray, cardType : "default", isEditable: true)
                imgSet.append(tempImgSet)
            }
        }
        imageSets = imgSet
    }
}
*/
