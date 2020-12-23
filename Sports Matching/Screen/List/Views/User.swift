//
//  User.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 21/10/20.
//  Copyright © 2020 Eshaan Govil. All rights reserved.
//

import Foundation
import UIKit

class User {
    var image: UIImage
    var name: String
    var sport: String
    var distance: Double
    var level: String
    var description: String
    var documentId: String
    
    init(image: UIImage, name: String, sport: String, distance: Double, level: String, description:String, documentId: String) {
        self.image = image
        self.name = name
        self.sport = sport
        self.distance = distance
        self.level = level
        self.description = description
        self.documentId = documentId
    }
    
}
