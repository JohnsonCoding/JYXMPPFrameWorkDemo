//
//  EdlChatViewController.swift
//  ClubWin
//
//  Created by 江勇 on 2019/12/11.
//  Copyright © 2019 edaili. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import XMPPFramework

let KImSupport = "kebi@izuf64jq4bbagoh6cy0x9iz" //客服

enum SendMessageStatus:Int {
    case sendMessageSuccess = 0//发送成功
    case sendMessageError = 1//发送失败
    case sendMessageing = 2//正在发送中
}

class EdlChatViewController:MessagesViewController, MessagesDataSource {
    
    fileprivate let welcomeMessages = "hi~请问你有什么疑问？"
    fileprivate let kefuModel = ChatUser(senderId: "000000", displayName: "kefu")
    fileprivate let kefuUUID = "kefuUUID"
    fileprivate let selfModel = ChatUser(senderId: "111111", displayName: "self")
    
    var messageList: [EdlChatModel] = []
    let refreshControl = UIRefreshControl()
    var sendMessageStatus = SendMessageStatus(rawValue: 0)
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EdlXMPPManager.shareInstance.removeSource()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "专属顾问"
        EdlXMPPManager.shareInstance.messagingDelegate = self
        configureMessageCollectionView()
        configureMessageInputBar()
        loadFirstMessages()
    }
    
    func loadFirstMessages() {
        let message = EdlChatModel.init(kind: .text(welcomeMessages), user: kefuModel, messageId: kefuUUID, date: Date())
        self.messageList = [message]
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
        
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        setupGestureRecognizers()
        
    }
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delaysTouchesBegan = true
        messagesCollectionView.addGestureRecognizer(tapGesture)
    }
    @objc
    private func handleTapGesture(_ gesture: UIGestureRecognizer) {
        guard gesture.state == .ended else { return }
        
        let touchLocation = gesture.location(in: messagesCollectionView)
        guard let indexPath = messagesCollectionView.indexPathForItem(at: touchLocation) else {
            messageInputBar.inputTextView.resignFirstResponder()
            return
        }
        
        let cell = messagesCollectionView.cellForItem(at: indexPath) as? MessageCollectionViewCell
        cell?.handleTapGesture(gesture)
    }
    
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self as InputBarAccessoryViewDelegate
        messageInputBar.inputTextView.tintColor = UIColor.red
        messageInputBar.sendButton.setTitleColor(UIColor.red, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.red,
            for: .highlighted
        )
    }
    
    // MARK: - Helpers
    
    func insertMessage(_ message: EdlChatModel) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    // 设置当前设备主人
    func currentSender() -> SenderType {
        return selfModel
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }

}

// MARK: - MessageCellDelegate

extension EdlChatViewController: MessageCellDelegate {
    func didTapBackground(in cell: MessageCollectionViewCell) {
        print("点击背景")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
        messageInputBar.inputTextView.resignFirstResponder()
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {

    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageInputBarDelegate

extension EdlChatViewController: InputBarAccessoryViewDelegate {
    
    // 点击发送按钮
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let senderJID = XMPPJID(string: KImSupport)
        let xmppMessage = XMPPMessage(type: "chat", to: senderJID)
        xmppMessage.addBody(inputBar.inputTextView.text!)
        EdlXMPPManager.shareInstance.xmppStream?.send(xmppMessage)
        title = "专属顾问"
        let components = inputBar.inputTextView.components
        self.insertMessages(components)
        self.messagesCollectionView.scrollToBottom(animated: true)
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                let message = EdlChatModel(text: str, user: selfModel, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}

extension EdlChatViewController: MessagingDelegate {
    // 接收消息
    func messageReceived(message: XMPPMessage) {
        if let messageBody = message.body {
            if message.type == "error" {
                sendMessageStatus = .sendMessageError
                messagesCollectionView.reloadSections([messageList.count - 1])
            }else{
                sendMessageStatus = .sendMessageSuccess
                let messageData = EdlChatModel.init(kind: .text(messageBody), user: self.kefuModel, messageId: self.kefuUUID, date: Date())
                self.insertMessage(messageData)
            }
            
        }else{
            sendMessageStatus = .sendMessageing
            if message.elements(forName: "composing").count == 1 {
                title = "对方正在输入..."
            }else{
                title = "专属顾问"
            }
        }
    }
    // 发送消息成功后处理
    func messageSent(message: XMPPMessage) {
        
    }
}
