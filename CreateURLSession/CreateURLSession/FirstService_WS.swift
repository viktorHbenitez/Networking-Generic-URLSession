//
//  FirstService_WS.swift
//  CreateURLSession
//
//  Created by Victor Hugo Benitez Bosques on 12/9/19.
//  Copyright © 2019 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit


class SecondService_WS: GenericURLSession{
  
  
  private let URL_Request = "https://jsonplaceholder.typicode.com/users"
  

  typealias CompletionBlock = (Dummy?, NSError?) -> Void
  
  
  override init() {
    super.init()
    pathURL = URL_Request
  }
  
  func executeService(hadler : @escaping CompletionBlock){
    
    DispatchQueue.global().async {
      
      // invoke request method
      self.requestService { (dctResponse, error) in
      
        DispatchQueue.main.async {
          if let error = error{
            if error.code == 0{
              hadler(self.parseobjects(dctResponse), error)
            }
            else{
              hadler(nil, error)
            }
            
          }
          
        }
      }
    }
    
  }
  
  
  func parseobjects( _ dctResponse : [[String : Any]]?) -> Dummy?{
    
    guard let dctResponse = dctResponse else {return nil}
    
    for objt in dctResponse{
      
      if let strUserName = objt["username"] as? String{
        print("username", strUserName)
      }
      
    }
    
    
    
    return nil
    
  }
  
  
}




class FirstService_WS: GenericURLSession {
  
  private let URL_Request = "http://httpbin.org/post"
  
  typealias CompletionBlock = (Dummy?, NSError?) -> Void

  
  override init() {
    super.init()
    pathURL = URL_Request
  }
  
  
  func executeService(_ parameters: [String : Any]?,
                      hadler : @escaping CompletionBlock){
    
    
    DispatchQueue.global().async { // background thread
      //    var algo:FirstService_WS? = self
      self.postService(with: parameters) { (dctResponse, error) in
        DispatchQueue.main.async {  // Main thread
          if let error = error {
            if error.code == 0{
              hadler(nil, error)
            }
            else{
              hadler(nil, error)
            }
          }
        }
        //        hadler(nil, error)
        //        algo = nil
        
        print("sdhmsagfjdashgdhjas")
        print("sdhmsagfjdashgdhjas")
      }
      
    }
  }
    
  func parseObjs(_ parameters : [String : Any]?) -> Dummy?{
    
    var dummy = Dummy()
    if let dctHeader = parameters?["headers"] as? [String : Any]{
      if let lenguage = dctHeader["Accept-Language"] as? String{
        dummy.strFirsParameter = lenguage
      }
    }
    print("parseObjs")
    return dummy
    
  }
  
  deinit {
    print("OS Reclaming memory for FirstService_WS - NO Retain Cycle / Leak!")
  }
}



struct Dummy {
  var strFirsParameter : String?
  var strSecondParameter : String?
  
}
