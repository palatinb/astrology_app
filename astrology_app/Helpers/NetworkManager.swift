//
//  NetworkManagers.swift
//  astrology_app
//
//  Created by Bence Palatin on 2021. 03. 06..
//

import Foundation

let signProperties = ["Aries":      ["value":"1","date":"III. 21. - IV. 19.","element":"fire","stability":"cardinal","planet":"Mars","polarity":"positive"],
                      "Taurus":     ["value":"2","date":"IV. 20. - V. 20.","element":"earth","stability":"solid","planet":"Venus","polarity":"negative"],
                      "Gemini":     ["value":"3","date":"V. 21. - VI. 21.","element":"air","stability":"variable","planet":"Mercury","polarity":"positive"],
                      "Cancer":     ["value":"4","date":"VI. 22. - VII. 22.","element":"water","stability":"cardinal","planet":"Moon","polarity":"negative"],
                      "Leo":        ["value":"5","date":"VII. 23. - VIII. 22.","element":"fire","stability":"solid","planet":"Sun","polarity":"positive"],
                      "Virgo":      ["value":"6","date":"VIII. 23. - IX. 22.","element":"earth","stability":"variable","planet":"Mercury","polarity":"negative"],
                      "Libra":      ["value":"7","date":"IX. 23. - X. 22.","element":"air","stability":"cardinal","planet":"Venus","polarity":"positive"],
                      "Scorpio":    ["value":"8","date":"X. 23. - XI. 21.","element":"water","stability":"solid","planet":"Pluto and Mars","polarity":"negative"],
                      "Saggitarius":["value":"9","date":"XI. 22. - XII. 21.","element":"fire","stability":"variable","planet":"Jupiter","polarity":"positive"],
                      "Capricorn":  ["value":"10","date":"XII. 22. - I. 19.","element":"earth","stability":"cardinal","planet":"Saturn","polarity":"negative"],
                      "Aquarius":   ["value":"11","date":"I. 20. - II. 18.","element":"air","stability":"solid","planet":"Uranus","polarity":"positive"],
                      "Pisces":     ["value":"12","date":"II. 19. - III. 20.","element":"water","stability":"variable","planet":"Neptune and Jupiter","polarity":"negative"]
]
let apiKey = "MUST BE FILLED BEFOORE USE!!!!4"
let apiUrl = "https://api.vedicastroapi.com/json/"
let geoApiUrl = "http://api.geonames.org/timezoneJSON?"

class predictionModel{
    var selectedInterval: String?
    var zodiac : String?
    var show_same : String
    var type : String
    var predType : String?
    var selectedDate : String?
    var name : String?
    var selectedSignProperties: [String : String] = [:]
    var selectedSign :String = ""
    var response : Dictionary<String,Any>?
    init() {
        show_same = "true"
        type = "big"
    }
    
    public var description : String {
        get {
            return "Prediction Model : zodiac : `\(String(describing: zodiac)) - predtype : `\(String(describing: predType))` - Dátum : `\(String(describing: selectedDate))` - Intervallum : `\(String(describing: selectedInterval))` - SelectedSign : \(selectedSign)"
        }
    }
}
class matchModel {
    var girl_sign : String?
    var boy_sign : String?
    var response : Dictionary<String,Any>?
}
class horoscopeModel {
    var horoscopeType : String?
    var dateOfBith : String?
    var timeOfBirth : String?
    var latitude : Double?
    var longitude : Double?
    var timezone : String?
    var response : AnyObject?
}
class NetworkManager {
    static func fetchPrediction(model: predictionModel, completion: @escaping (Dictionary<String, Any>) -> Void) {
        print(model.description)
        var request : URLRequest
        let requestUrl : URL
        var requestUrlStr : String = ""
        if model.predType!.contains("daily") {
//            Daily Prediction
            request = URLRequest(url: URL(string: apiUrl + "prediction/\(model.predType!)?" + "zodiac=\(model.zodiac!))&show_same=\(model.show_same)&date=\(model.selectedDate!)&type=\(model.type)&api_key=\(apiKey)")!)
        }else if model.predType!.contains("week") {
//            Weekly prediction
            print(apiUrl + "prediction/\(model.predType!)?" + "zodiac=\(model.zodiac!)&show_same=\(model.show_same)&week=\(model.selectedInterval!)&type=\(model.type)&api_key=\(apiKey)")
            request = URLRequest(url: URL(string: apiUrl + "prediction/\(model.predType!)?" + "zodiac=\(model.zodiac!))&show_same=\(model.show_same)&week=\(model.selectedInterval!)&type=\(model.type)&api_key=\(apiKey)")!)
        } else {
//            Numerology
            print(apiUrl + "prediction/\(String(describing: model.predType!))?" + "name=\(model.name!.replacingOccurrences(of: " ", with: "+"))&show_same=\(model.show_same)&date=\(model.selectedDate!)&api_key=\(apiKey)")
            requestUrlStr.append(apiUrl)
            requestUrlStr.append("prediction/\(model.predType!)?")
            requestUrlStr.append("name=\(model.name!.replacingOccurrences(of: " ", with: "+"))")
            requestUrlStr.append("&date=\(model.selectedDate!)")
            requestUrlStr.append("&api_key=\(apiKey)")
            
            requestUrl = URL(string: requestUrlStr)!
            request = URLRequest(url: requestUrl)
            
        }

        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                var resultDictionary = Dictionary<String,Dictionary<String,String>>()
                var midDictionary = Dictionary<String,String>()
                if model.predType!.contains("num"){
                    let responeJSON = json["response"]!
                    let params : [String] = ["title","number","meaning","description"]
                    midDictionary = GetNumerologyDetails(input: responeJSON["destiny"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["destiny"] = midDictionary
                    
                    midDictionary = GetNumerologyDetails(input: responeJSON["personality"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["personality"] = midDictionary
                    
                    midDictionary = GetNumerologyDetails(input: responeJSON["attitude"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["attitude"] = midDictionary
                    
                    midDictionary = GetNumerologyDetails(input: responeJSON["character"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["character"] = midDictionary
                    
                    midDictionary = GetNumerologyDetails(input: responeJSON["soul"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["soul"] = midDictionary
                    
                    midDictionary = GetNumerologyDetails(input: responeJSON["agenda"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["agenda"] = midDictionary
                    
                    midDictionary = GetNumerologyDetails(input: responeJSON["purpose"] as! Dictionary<String,Any>, args: params)
                    resultDictionary["purpose"] = midDictionary
                    
                    completion(resultDictionary)
                }
                else {
                    //print(json)
                    let responeJSON = json["response"]!
                    //predictionRSP = responeJSON["bot_response"]!! as! String
                    //print(predictionRSP)
                    let responseDict = responeJSON as! Dictionary<String, Any>
                    completion(responseDict)
                }
            } catch {
                print("error")
            }
            
        })
        task.resume()
    }
    
    static func GetNumerologyDetails(input: Dictionary<String,Any>, args: [String])-> Dictionary<String,String> {
        var out : Dictionary<String,String> = [:]
        for arg in args {
            out[arg] = (input[arg] as! String)
        }
        return out
    }
    
    static func fetchMatching(model: matchModel, completion: @escaping (Dictionary<String, Any>) -> Void) {
        var request = URLRequest(url: URL(string: apiUrl + "matching/western?" + "boy_sign=\(model.boy_sign!)&girl_sign=\(model.girl_sign!)&api_key=\(apiKey)")!)
        print(apiUrl + "matching/western?" + "boy_sign=\(model.boy_sign!)&girl_sign=\(model.girl_sign!)&api_key=\(apiKey)")
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                //print(json)
                let responeJSON = json["response"]!
                //predictionRSP = responeJSON["bot_response"]!! as! String
                let responseDict = responeJSON as! Dictionary<String, Any>
                completion(responseDict)
            } catch {
                print("error")
            }
            
        })
        task.resume()
    }
    static func fetchHoroscope(model: horoscopeModel, completion: @escaping (String) -> Void) {
        var predictionRSP = ""
        var request = URLRequest(url: URL(string: apiUrl + "horoscope/findascendant?" + "dob=\(model.dateOfBith!)&tob=\(model.timeOfBirth!)&lat=\(model.latitude!)&lon=\(model.longitude!)&tz=\(model.timezone!)&api_key=\(apiKey)")!)
        //print(apiUrl + "horoscope/\(model.horoscopeType!)?" + "dob=\(model.dateOfBith!)&tob=\(model.timeOfBirth!)&lat=\(model.latitude!)&lon=\(model.longitude!)&tz=\(model.timezone!)&api_key=\(apiKey)")
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                //print(json)
                let responeJSON = json["response"]!
                predictionRSP = responeJSON["bot_response"]!! as! String
                //print(predictionRSP)
                completion(predictionRSP)
            } catch {
                print("error")
            }
            
        })
        task.resume()
    }
    
    static func fetchTimeZone(model: horoscopeModel, completion: @escaping (String) -> Void) {
        var RSP = ""
        var request = URLRequest(url: URL(string: geoApiUrl + "lat=\(String(format: "%.2f", model.latitude!))&lng=\(String(format: "%.2f", model.longitude!))&username=palatin.bence")!)
        print(geoApiUrl + "lat=\(String(format: "%.2f", model.latitude!))&lng=\(String(format: "%.2f", model.longitude!))&username=palatin.bence")
        request.httpMethod = "GET"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                
                //print(json)
                let responeJSON = json["gmtOffset"]!
                let rspDouble = responeJSON as! Double
                RSP = String(format: "%.1f", rspDouble)
                print(RSP)
                completion(RSP)
            } catch {
                print("error")
            }
            
        })
        task.resume()
    }
}
