//
//  AzureTranslator.swift
//  TalkingBooghi
//
//  Created by Donghoon Shin on 12/10/2018.
//  Copyright © 2018 Donghoon Shin. All rights reserved.
//

import UIKit

func translateText(stringToBeTranslated: String, txtField: UITextField) {
    let selectedFromLangCode = "en"
    let selectedToLangCode = "ko"
    
    struct encodeText: Codable {
        var text = String()
    }
    
    let azureKey = "54ddfb9634d0462eb5b64d92dd5acd48"
    
    let contentType = "application/json"
    let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
    let host = "dev.microsofttranslator.com"
    let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
    
    let text2Translate = stringToBeTranslated
    var encodeTextSingle = encodeText()
    var toTranslate = [encodeText]()
    let jsonEncoder = JSONEncoder()
    
    encodeTextSingle.text = text2Translate
    toTranslate.append(encodeTextSingle)
    
    let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
    let url = URL(string: apiURL)
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    request.addValue(contentType, forHTTPHeaderField: "Content-Type")
    request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
    request.addValue(host, forHTTPHeaderField: "Host")
    request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
    request.httpBody = jsonToTranslate
    
    let config = URLSessionConfiguration.default
    let session =  URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        if responseError != nil {
            print("this is the error ", responseError!)
        }
        print("*****")
        struct ReturnedJson: Codable {
            var translations: [TranslatedStrings]
        }
        struct TranslatedStrings: Codable {
            var text: String
            var to: String
        }
        
        let jsonDecoder = JSONDecoder()
        if let translations = responseData {
            let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: translations)
            let numberOfTranslations = langTranslations!.count - 1
            
            DispatchQueue.main.async {
                if let langTrans = langTranslations {
                    txtField.text = langTrans[0].translations[numberOfTranslations].text
                } else {
                    txtField.text = stringToBeTranslated
                }
            }
        } else {
            DispatchQueue.main.async {
                txtField.text = stringToBeTranslated
            }
        }
    }
    task.resume()
}

func translateTextToString(stringToBeTranslated: String, completion: @escaping (String) -> Void) {
    let selectedFromLangCode = "en"
    let selectedToLangCode = "ko"
    
    struct encodeText: Codable {
        var text = String()
    }
    
    let azureKey = "54ddfb9634d0462eb5b64d92dd5acd48"
    
    let contentType = "application/json"
    let traceID = "A14C9DB9-0DED-48D7-8BBE-C517A1A8DBB0"
    let host = "dev.microsofttranslator.com"
    let apiURL = "https://dev.microsofttranslator.com/translate?api-version=3.0&from=" + selectedFromLangCode + "&to=" + selectedToLangCode
    
    let text2Translate = stringToBeTranslated
    var encodeTextSingle = encodeText()
    var toTranslate = [encodeText]()
    let jsonEncoder = JSONEncoder()
    
    encodeTextSingle.text = text2Translate
    toTranslate.append(encodeTextSingle)
    
    let jsonToTranslate = try? jsonEncoder.encode(toTranslate)
    let url = URL(string: apiURL)
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    request.addValue(azureKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
    request.addValue(contentType, forHTTPHeaderField: "Content-Type")
    request.addValue(traceID, forHTTPHeaderField: "X-ClientTraceID")
    request.addValue(host, forHTTPHeaderField: "Host")
    request.addValue(String(describing: jsonToTranslate?.count), forHTTPHeaderField: "Content-Length")
    request.httpBody = jsonToTranslate
    
    let config = URLSessionConfiguration.default
    let session =  URLSession(configuration: config)
    
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        if responseError != nil {
            print("this is the error ", responseError!)
        }
        print("*****")
        struct ReturnedJson: Codable {
            var translations: [TranslatedStrings]
        }
        struct TranslatedStrings: Codable {
            var text: String
            var to: String
        }
        
        let jsonDecoder = JSONDecoder()
        if let responsTranslation = responseData {
            let langTranslations = try? jsonDecoder.decode(Array<ReturnedJson>.self, from: responsTranslation)
            let numberOfTranslations = langTranslations!.count - 1
            
            DispatchQueue.main.async {
                if let langTrans = langTranslations {
                    completion(langTrans[0].translations[numberOfTranslations].text)
                } else {
                    completion(text2Translate)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(text2Translate)
            }
        }
    }
    task.resume()
}
