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
  
  
  //    postService( []){
  //    [unowned self](data, error) in
  //
  //    error == nil {
  //
  //    }
  //    self.funcionque transforma a modelo de ne(data)
  //    Dispa
  //    }

  typealias Handler = ( [String : Any]? , NSError?) -> Void
  
  func postService(with dctRequest : [String : Any]? , completion: @escaping Handler){
    
    
    // Create a configurations session
    let configurationSession = URLSessionConfiguration.default
    
    
    // Create a session
    let session = URLSession(configuration: configurationSession, delegate: nil, delegateQueue: nil)
    //      let session = URLSession(configuration: configurationSession, delegate: self, delegateQueue: OperationQueue.ma)
    
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
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//        print("httpResponse Error", (response as? HTTPURLResponse)?.statusCode)
        return
      }
      
      
      guard let data = data else { return
//        completion(nil, NSError(domain: "dataNilError", code: -10011, userInfo: nil))
        print(" data error.debugDescription", error.debugDescription)
      }
      
      
      do{
        guard let parseData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
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
