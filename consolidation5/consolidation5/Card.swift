//
//  Card.swift
//  consolidation5
//
//  Created by Lui on 09/11/21.
//

import UIKit

class Card: NSObject, Codable {
    
    var image: String
    var name: String
    
    init(name:String, image:String) {
        self.name = name
        self.image = image
    }
    
}
