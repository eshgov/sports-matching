//
//  ChatUser.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 9/9/21.
//  Copyright © 2021 Eshaan Govil. All rights reserved.
//

import Foundation
import MessageKit

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
