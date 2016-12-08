
//
//  Mongo.swift
//  Tulube
//
//  Created by James Ormond on 11/28/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation

class Mongo {
    
    class func MongoObjectId() -> String {
        
        let time = String(Int(NSDate().timeIntervalSince1970), radix: 16, uppercase: false)
        let machine = String(arc4random_uniform(900000) + 100000)
        let pid = String(arc4random_uniform(9000) + 1000)
        let counter = String(arc4random_uniform(900000) + 100000)
        return time + machine + pid + counter
        
    }
    
}
