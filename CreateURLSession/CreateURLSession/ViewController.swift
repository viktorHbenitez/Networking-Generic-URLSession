//
//  ViewController.swift
//  CreateURLSession
//
//  Created by Victor Hugo Benitez Bosques on 12/9/19.
//  Copyright © 2019 Victor Hugo Benitez Bosques. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  
  // FirstService_WS

  @IBAction func tappedButton(){

    let parameters = ["hello" : "world"]
    invokeFirstService(parameters)
    
  }
  
  
  private func invokeFirstService(_ parameters : [String : Any]?){
    let objService = FirstService_WS()
    objService.executeService(parameters) { (obj, error) in
      if let error = error{
        
        if error.code == 0{
          print("Success", error.localizedDescription)
        }else{
          print("Error of code", error.code, error.localizedDescription)
        }
      }
      
    }
  }
  
  
}

