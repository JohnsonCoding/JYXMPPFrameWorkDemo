//
//  EdlChatModel.swift
//  ClubWin
//
//  Created by 江勇 on 2019/12/12.
//  Copyright © 2019 edaili. All rights reserved.
//

import UIKit
import MessageKit

struct EdlChatModel: MessageType {
    
    var messageId: String
    var sender: SenderType {
        return user
    }
    var user: ChatUser
    var sentDate: Date
    var kind: MessageKind

    init(kind: MessageKind, user: ChatUser, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, user: ChatUser, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
}

struct ChatUser: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
