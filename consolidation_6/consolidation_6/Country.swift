//
//  Country.swift
//  consolidation_6
//
//  Created by Lui on 23/11/21.
//

import UIKit

class Country: NSObject, Codable {

    var name: String!
    var population: String!
    var language: String!
    var image: String!
    
    init(name: String, image: String, language: String, population: String) {
        self.name = name
        self.image = image
        self.language = language
        self.population = population
    }
    
}
