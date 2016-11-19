//
//  ViewController.swift
//  PhotoBrowser500px
//
//  Created by Crul on 2016-11-19.
//  Copyright © 2016 Sid. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let CONSUMER_KEY = "fuxM7DPmpU4dQuFubUbQYOcLRUbeQBOGtqlzl56r"
        let parameters: Parameters = ["consumer_key": CONSUMER_KEY,
                                      "feature": "fresh_today",
                                      "image_size": 440,
                                      "exclude": "Nude"]
        
//        Alamofire.request("https://api.500px.com/v1/photos", parameters: parameters).responseString { (str: DataResponse<String>) in
//            debugPrint("response here")
//            debugPrint(str)
//        }
        
        Alamofire.request("https://api.500px.com/v1/photos", parameters: parameters).responseJSON { (json: DataResponse<Any>) in
            debugPrint("json response here")
            debugPrint(json)
            //json.result.value! as! NSDictionary)["photos"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

