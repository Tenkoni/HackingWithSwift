//
//  Note.swift
//  Consolidation_8
//
//  Created by Lui on 18/01/22.
//

import UIKit

class Note: NSObject, Codable {
    
    var title: String
    var content: String
 
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
}
