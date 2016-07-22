//
//  HomeController.swift
//  HelloWorldExpress
//
//  Created by Nermin Sehic on 6/30/16.
//  Copyright © 2016 Crossroad Labs. All rights reserved.
//

import Foundation
import Express
import BrightFutures
import Result

class HomeController {
    
//    let urlAsString = "http://infinigag.k3min.eu/trending"
//    let urlSession = NSURLSession.sharedSession()
    
    class func index() -> Action<AnyContent> {
        print("called")
        return Action<AnyContent>.render("index", context: ["hello": "caj", "swift": "Swift", "express": "Express!"])
    }
    
    static func fetchData() -> Future<[String], NSError> {
        
        // Define URL and posts array
        let urlSession = NSURLSession.sharedSession()
        let url = NSURL(string: "http://infinigag.k3min.eu/trending")!
        
        // Make a request
        return urlSession.dataWithURL(url).flatMap { data in
            materialize {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions(rawValue: 0))
                
                guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                    throw NSError(domain: "express.example", code: 1, userInfo: ["description": "Not a Dictionary"])
                }
                
                var posts = [String]()
                
                // Map the JSON response to array
                for (key, value) in JSONDictionary {
                    
                    if(key as! String == "data") {
                        
                        for data in value as! NSArray {
                            
                            posts.append(data["images"]!!["large"] as! String)
                            
                        }
                    }
                }
                
                return posts
            }
        }
    }
    
    func futurify<Payload>(fun:((Payload)->Void)->Void) -> Future<Payload, AnyError> {
        let p = Promise<Payload, AnyError>()
        
        fun { payload in
            p.success(payload)
        }
        
        return p.future
    }
}

