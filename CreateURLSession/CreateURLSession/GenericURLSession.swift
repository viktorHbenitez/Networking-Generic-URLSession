//
//  GenericURLSession.swift
//  CreateURLSession
//
//  Created by Victor Hugo Benitez Bosques on 12/9/19.
//  Copyright © 2019 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit

class GenericURLSession: NSObject {
  let strBaseCoDiURL = ""
  var pathURL : String?
  
  // MARK: - Type Alias
  typealias JSONDictionary = [String : Any]
  typealias JSONArryDictionary = [[String : Any]]
  
  typealias QueryDictResult   = ([String : Any]? , NSError?) -> Void
  typealias QueryArrayResult  = ([[String : Any]]?, NSError?) -> Void
  
  
  func postService(with dctRequest : [String : Any]? ,
                   completion: @escaping QueryDictResult){
    
    // Create a configurations session
    let configurationSession = URLSessionConfiguration.default
    
    // Create a session
    let session = URLSession(configuration: configurationSession)
    
    /**
     Create the URL for the request
     Setup the URL
     */
    guard let pathURL = pathURL, let url = URL(string: String(format: "%@%@", strBaseCoDiURL, pathURL))
      else { return completion(nil, NSError(domain: "DdataNilError", code: -10001 , userInfo: nil)) }
    
    var request = URLRequest(url: url)
    request.httpMethod = "Post" // Set http method
    
    // HTTP Headers
    request.addValue("text/json", forHTTPHeaderField: "Content-Type")
    request.addValue("text/json", forHTTPHeaderField: "Accept")
    
    guard let dctRequest = dctRequest else { return }
//            request.httpBody = dctRequest.percentEscaped().data(using: .utf8)
    request.httpBody = try? JSONSerialization.data(withJSONObject: dctRequest, options: .prettyPrinted)
    
    
    // Create the task
    let task = session.dataTask(with: request) {data, response, error in
      
      if error != nil{
        completion(nil, NSError(domain: error.debugDescription, code: -10011, userInfo: nil))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        completion(nil, NSError(domain: "Error HTTP Response", code:  (response as? HTTPURLResponse)?.statusCode ?? -1001, userInfo: nil))
        return
      }
      
      guard let data = data else { return
        completion(nil, NSError(domain: "dataNilError", code: -10011, userInfo: nil))
      }
      
      
      do{
        guard let parseData = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary else {
          return completion(nil, NSError(domain: "parseData", code: -10012 , userInfo: nil))
        }
        
        if let strResponse = String.init(data: data, encoding: .utf8){
          print("RESPONSE JSON : %@", strResponse)
        }
        
        completion(parseData, NSError(domain: "BD.ResponseSession", code: 0, userInfo: nil))
        
      }catch let error{
        completion(nil, error as NSError)
      }
    }
    task.resume()
  }
  
  
  
  func requestService(completion: @escaping QueryArrayResult){
    
    // Create a configurations session
    let configurationSession = URLSessionConfiguration.default
    
    // Create a session
    let session = URLSession(configuration: configurationSession)
    
    /**
     Create the URL for the request
     Setup the URL
     */
    guard let pathURL = pathURL, let url = URL(string: String(format: "%@%@", strBaseCoDiURL, pathURL))
      else { return completion(nil, NSError(domain: "DdataNilError", code: -10001 , userInfo: nil)) }
    
    // Create Data Task
    let task = session.dataTask(with: url) { data, response, error in
      
      if error != nil{
        completion(nil, NSError(domain: error.debugDescription, code: -10011, userInfo: nil))
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        completion(nil, NSError(domain: "Error HTTP Response", code:  (response as? HTTPURLResponse)?.statusCode ?? -1001, userInfo: nil))
        return
      }
      
      guard let data = data else { return
        completion(nil, NSError(domain: "dataNilError", code: -10011, userInfo: nil))
      }
      
      
      do{
        if let strResponse = String.init(data: data, encoding: .ascii){
          print("Response format URL", strResponse)
        }
        
        if let dataResponse = String.init(data: data, encoding: .ascii)?.data(using: .utf8){
          guard let parseData = try JSONSerialization.jsonObject(with: dataResponse, options: .mutableContainers) as? JSONArryDictionary else {
            return completion(nil, NSError(domain: "parseData", code: -10012 , userInfo: nil))
          }
          
          completion(parseData, NSError(domain: "BD.ResponseSession", code: 0, userInfo: nil))
        }
        
      }catch let error{
        completion(nil, error as NSError)
      }
    }
    
    task.resume()
  }
  
  
}



extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
