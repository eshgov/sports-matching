//
//  ChatViewController.swift
//  Sports Matching
//
//  Created by Eshaan Govil on 6/9/21.
//  Copyright © 2021 Eshaan Govil. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType{
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {

    var otherUserData: User?
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }() 
    
    public let otherUserEmail: String
    public var isNewConversation = false
    
    private var messages = [Message]()
    private let selfSender = Sender(senderId: Auth.auth().currentUser!.uid, displayName: "")
    
    init(with email: String){
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    
    /// Creates a new conversation with target user email and first message sent
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message){
        
    }
    
    /// fetches and returns all convos for the user with email
    public func getAllConversations(for email: String){
        
    }
    
    /// gets all msgs for given convo
    public func getAllMessagesForConversation(with uid: String){
        
    }
    
    /// sends message with target convo and message
    public func sendMessage(to conversation: String, message: Message){
        
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        // send message
        
        if isNewConversation{
            // create conversation in database
            let message = Message(sender: selfSender,
                                  messageId: createMessageId(),
                                  sentDate: Date(),
                                  kind: .text(text))
            createNewConversation(with: otherUserEmail, firstMessage: message)
        } else {
            // add to existing conversation data
        }
    }
    
    private func createMessageId() -> String{
        //date, otherUserEmail, senderEmail
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(String(describing: Auth.auth().currentUser?.email))_\(dateString)"
        print("created message id: \(newIdentifier)")
        return newIdentifier
}
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

}
