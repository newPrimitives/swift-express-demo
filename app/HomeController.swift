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

class HomeController {
    
//    let urlAsString = "http://infinigag.k3min.eu/trending"
//    let urlSession = NSURLSession.sharedSession()
    
    class func index() -> Action<AnyContent> {
        print("called")
        return Action<AnyContent>.render("index", context: ["hello": "caj", "swift": "Swift", "express": "Express!"])
    }
    
    static func fetchData(completionHandler: (posts: [String]) -> ()) {
        
        // Define URL and posts array
        let urlSession = NSURLSession.sharedSession()
        let url = NSURL(string: "http://infinigag.k3min.eu/trending")!
        
        var posts = [String]()
        
        // Make a request
        let request = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in
            
            // Try-catch block
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
                
                guard let JSONDictionary :NSDictionary = JSON as? NSDictionary else {
                    print("Not a Dictionary")
                    return
                }
                
                // Map the JSON response to array
                for (key, value) in JSONDictionary {
                    
                    if(key as! String == "data") {
                        
                        for data in value as! NSArray {
                            
                            posts.append(data["images"]!!["large"] as! String)
                            
                        }
                    }
                }
                // Call completion handler
                completionHandler(posts: posts)
                
                return
                
                
            } catch let JSONError as NSError {
                print("\(JSONError)")
            }
        })
        
        request.resume()
    }
    
    func futurify<Payload>(fun:((Payload)->Void)->Void) -> Future<Payload, AnyError> {
        let p = Promise<Payload, AnyError>()
        
        fun { payload in
            p.success(payload)
        }
        
        return p.future
    }
}

