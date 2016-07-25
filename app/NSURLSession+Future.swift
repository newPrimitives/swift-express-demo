//
//  NSURLSession+Future.swift
//  HelloWorldExpress
//
//  Created by Daniel Leping on 22/07/2016.
//  Copyright © 2016 Crossroad Labs. All rights reserved.
//

import Foundation
import BrightFutures

extension NSURLSession {
    func dataWithURL(url: NSURL) -> Future<NSData, NSError> {
        let promise = Promise<NSData, NSError>()
        
        let request = self.dataTaskWithURL(url) { data, response, error in
            guard let data = data else {
                let failure = error ?? NSError(domain: "express.example", code: 0, userInfo: nil)
                promise.failure(failure)
                return
            }
            promise.success(data)
        }
        request.resume()
        
        return promise.future
    }
}