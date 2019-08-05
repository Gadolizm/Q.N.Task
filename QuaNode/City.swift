//
//  City.swift
//  QuaNode
//
//  Created by Gado on 8/5/19.
//  Copyright © 2019 Gado. All rights reserved.
//

import Foundation


import ObjectMapper

class City: Mappable {
    

    
    var country :String?
    var name : String?
    var latitude: String?
    var longitude: String?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        country <- map["country"]
        name <- map["name"]
        latitude <- map["lat"]
        longitude <- map["lng"]
    
    }
    
}


