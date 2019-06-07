//
//  DataStructure.swift
//  PictureStory
//
//  Created by Donghoon Shin on 2018. 7. 26..
//  Copyright © 2018년 Donghoon Shin. All rights reserved.
//

import Foundation
import Firebase
import Localize_Swift


struct ImageSet: Codable {

    var category: String
    var imageName: String
    var imagePath: String
    var tagName = [String]()
    var tagPath = [String]()
    var cardType = String()
    var isEditable = true
    
    init(category: String, imageName: String, imagePath: String, tagName: [String], tagPath: [String], cardType: String, isEditable: Bool) {
        self.category = category
        self.imageName = imageName
        self.imagePath = imagePath
        self.tagName = tagName
        self.tagPath = tagPath
        self.cardType = cardType
        self.isEditable = isEditable
    }
}


var preSet: [ImageSet] = [
    ImageSet(category: "음식", imageName: "라면", imagePath: "라면", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "볶음밥", imagePath: "볶음밥", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "카레", imagePath: "카레", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "돈까스", imagePath: "돈까스", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "떡볶이", imagePath: "떡볶이", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "스파게티", imagePath: "스파게티", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "햄버거", imagePath: "햄버거", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "", imagePath: "defaultChoose1", tagName: ["주세요"], tagPath: ["주세요"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "주스 갈아주세요", imagePath: "갈아요", tagName: ["딸기", "바나나", "토마토"], tagPath: ["딸기", "바나나", "토마토"], cardType: "default", isEditable: false),
     ImageSet(category: "음식", imageName: "뭐 먹고싶어?", imagePath: "짜장면", tagName: ["짜장면", "짬뽕"], tagPath: ["짜장면", "짬뽕"], cardType: "sorted", isEditable: false),
     ImageSet(category: "음식", imageName: "", imagePath: "치킨", tagName: ["치킨", "피자"], tagPath: ["치킨", "피자"], cardType: "sorted", isEditable: false),
     ImageSet(category: "음식", imageName: "", imagePath: "defaultChoose2", tagName: ["", ""], tagPath: ["defaultChoose2", "defaultChoose3"], cardType: "sorted", isEditable: false),
    
    //활동
    ImageSet(category: "활동", imageName: "퍼즐", imagePath: "퍼즐", tagName: ["주세요", "끝났어요"], tagPath: ["주세요", "끝났어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "레고", imagePath: "레고", tagName: ["주세요", "끝났어요"], tagPath: ["주세요", "끝났어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "색연필", imagePath: "색연필", tagName: ["주세요", "끝났어요"], tagPath: ["주세요", "끝났어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "음악", imagePath: "음악듣기", tagName: ["듣고싶어요", "끝났어요"], tagPath: ["듣고싶어요", "끝났어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "", imagePath: "defaultChoose4", tagName: ["주세요", "끝났어요"], tagPath: ["주세요", "끝났어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "화장실", imagePath: "화장실", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "집", imagePath: "defaultChoose5", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "학교", imagePath: "defaultChoose6", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "마트", imagePath: "defaultChoose7", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "공원", imagePath: "공원", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "수영장", imagePath: "수영장", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "영화관", imagePath: "영화관", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "동물원", imagePath: "동물원", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    ImageSet(category: "활동", imageName: "놀이공원", imagePath: "놀이공원", tagName: ["가고싶어요"], tagPath: ["가고싶어요"], cardType: "default", isEditable: false),
    
    //사람
    ImageSet(category: "사람", imageName: "엄마", imagePath: "defaultChoose8", tagName: [], tagPath: [], cardType: "default", isEditable: false),
    ImageSet(category: "사람", imageName: "아빠", imagePath: "defaultChoose9", tagName: [], tagPath: [], cardType: "default", isEditable: false),
    ImageSet(category: "사람", imageName: "선생님", imagePath: "defaultChoose10", tagName: [], tagPath: [], cardType: "default", isEditable: false),
    
    //일과
    ImageSet(category: "일과", imageName: "월요일", imagePath: "집", tagName: ["집", "학교버스", "부기중학교", "601버스", "언어치료실", "집"], tagPath: ["집", "버스", "교실", "601버스", "언어치료실", "집"], cardType: "routine", isEditable: false),
    ImageSet(category: "일과", imageName: "6월 20일 소풍", imagePath: "집", tagName: ["집", "아빠차", "피자", "호수공원", "아빠차", "집"], tagPath: ["집", "아빠차", "피자", "공원", "아빠차", "집"], cardType: "routine", isEditable: false),
    ImageSet(category: "일과", imageName: "", imagePath: "defaultChoose11", tagName: ["","","",""], tagPath: ["defaultChoose11", "defaultChoose12", "defaultChoose13", "defaultChoose14"], cardType: "routine", isEditable: false),
    
    //오늘의 일기
    ImageSet(category: "오늘의 일기", imageName: "산으로 등산을 갔어요", imagePath: "등산", tagName: ["엄마", "달걀", "물"], tagPath: ["엄마", "달걀", "물"], cardType: "default", isEditable: false),
    ImageSet(category: "오늘의 일기", imageName: "호수공원으로 소풍을 갔어요", imagePath: "소풍", tagName: ["샌드위치", "돗자리", "재밌었어요"], tagPath: ["샌드위치", "돗자리", "기뻐요"], cardType: "default", isEditable: false),
    ImageSet(category: "오늘의 일기", imageName: "", imagePath: "defaultChoose15", tagName: ["", "", ""], tagPath: ["defaultChoose16", "defaultChoose16", "defaultChoose16"], cardType: "default", isEditable: false),
    
    //일상대화
    ImageSet(category: "일상대화", imageName: "기분", imagePath: "기뻐요", tagName: ["기뻐요", "슬퍼요", "최고에요", "화가 나요", "재밌어요", "졸려요"], tagPath: ["기뻐요", "슬퍼요", "최고에요", "화가 나요", "재밌어요", "졸려요"], cardType: "sorted", isEditable: false),
    ImageSet(category: "일상대화", imageName: "날씨", imagePath: "맑아요", tagName: ["맑아요", "흐려요", "비가 와요", "눈이 와요"], tagPath: ["맑아요", "흐려요", "비가 와요", "눈이 와요"], cardType: "sorted", isEditable: false),
    ImageSet(category: "일상대화", imageName: "하루", imagePath: "낮", tagName: ["낮", "밤"], tagPath: ["낮", "밤"], cardType: "sorted", isEditable: false),
    ImageSet(category: "일상대화", imageName: "계절", imagePath: "봄", tagName: ["봄","여름","가을","겨울"], tagPath: ["봄","여름","가을","겨울"], cardType: "sorted", isEditable: false)
]

var category: [String] {
    get {
        return UserDefaults.standard.array(forKey: "category") as? [String] ?? ["음식", "활동", "사람", "일과", "오늘의 일기", "일상대화"]
    } set {
        UserDefaults.standard.set(newValue, forKey: "category")
        UserDefaults.standard.synchronize()
    }
}

var imageSets: [ImageSet] {
    get {
        let data1 = UserDefaults.standard.value(forKey: "imageSets") as? Data
        let imageSets2 = try? PropertyListDecoder().decode(Array<ImageSet>.self, from: data1!)
        return imageSets2 ?? preSet
    } set {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "imageSets")
        UserDefaults.standard.synchronize()
    }
}

var viewLayout: String {
    get {
        return UserDefaults.standard.string(forKey: "viewLayout") ?? "threebythree"
    } set {
        UserDefaults.standard.set(newValue, forKey: "viewLayout")
        UserDefaults.standard.synchronize()
    }
}

var experimentID: String {
    get {
        return UserDefaults.standard.string(forKey: "experimentID") ?? ""
    } set {
        UserDefaults.standard.set(newValue, forKey: "experimentID")
        UserDefaults.standard.synchronize()
    }
}

var speechSpeed: Float {
    get {
        return UserDefaults.standard.float(forKey: "speechSpeed")
    } set {
        UserDefaults.standard.set(newValue, forKey: "speechSpeed")
        UserDefaults.standard.synchronize()
    }
}

var notInitial: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "notInitial")
    } set {
        UserDefaults.standard.set(newValue, forKey: "notInitial")
        UserDefaults.standard.synchronize()
    }
}

var isTutorialShown: Bool {
    get {
        return UserDefaults.standard.bool(forKey: "isTutorialShown")
    } set {
        UserDefaults.standard.set(newValue, forKey: "isTutorialShown")
        UserDefaults.standard.synchronize()
    }
}
