//
//  Chat.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 9/9/21.
//  Copyright © 2021 Eshaan Govil. All rights reserved.
//

import Foundation
import UIKit

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return ["users": users]
    }
}

extension Chat {
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
}
