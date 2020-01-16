//
//  EdlChatUIViewController.swift
//  ClubWin
//
//  Created by 江勇 on 2019/12/12.
//  Copyright © 2019 edaili. All rights reserved.
//

import UIKit
//import Kingfisher
import MessageKit

final class EdlChatUIViewController: EdlChatViewController {
    
    var avatarImage = UIImage()
    override func configureMessageCollectionView() {
        
        super.configureMessageCollectionView()
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageIncomingAvatarPosition(AvatarPosition.init(vertical: .messageLabelTop))
        layout?.setMessageOutgoingAvatarPosition(AvatarPosition.init(vertical: .messageLabelTop))
        layout?.setMessageIncomingAvatarSize(CGSize(width: 40, height: 40))
        layout?.setMessageOutgoingAvatarSize(CGSize(width: 40, height: 40))
        
        layout?.setMessageIncomingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageIncomingAccessoryViewPadding(HorizontalEdgeInsets(left: 8, right: 0))
        layout?.setMessageOutgoingAccessoryViewSize(CGSize(width: 30, height: 30))
        layout?.setMessageOutgoingAccessoryViewPadding(HorizontalEdgeInsets(left: 0, right: 8))
        
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.backgroundColor = UIColor.Hex(with: "F4F4F4")
        
        avatarImage = #imageLiteral(resourceName: "kefuIcon")
    }
    
    override func configureMessageInputBar() {
        super.configureMessageInputBar()
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.separatorLine.backgroundColor = UIColor.Hex(with: "EEEEEE")
        messageInputBar.inputTextView.tintColor = UIColor.Hex(with: "6010FF")
        messageInputBar.inputTextView.backgroundColor = UIColor.Hex(with: "F4F4F4")
        messageInputBar.inputTextView.placeholder = "我想说..."
        messageInputBar.inputTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        messageInputBar.inputTextView.placeholderTextColor = UIColor.Hex(with: "CCCCCC")
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 10, left: 12, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.cornerRadius = 5.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 18, left: 0, bottom: 8, right: 0)
        
        messageInputBar.sendButton.setTitle("发送", for: .normal)
        messageInputBar.sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.setTitleColor(UIColor.Hex(with: "6010FF"), for: .normal)
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.setTitleColor(UIColor.Hex(with: "CCCCCC"), for: .normal)
                })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? TextMessageCell{
            cell.backgroundColor = UIColor.Hex(with: "F4F4F4")
            cell.messageTopLabel.isHidden = true
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        print("----\(message)======\(indexPath.section)")
        if indexPath.section == 0 {
            return NSAttributedString(string: string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }else{
            let startTime = string(from: messageList[messageList.count - 2].sentDate)
            let endTime = string(from: messageList[messageList.count - 1].sentDate)
            let dateIntervalInt = dateInterval(startTime: startTime, endTime: endTime)
            if dateIntervalInt >= 3 && messageList.count == indexPath.section + 1 {
                return NSAttributedString(string: string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            }
        }
        return nil
    }

    public func string(from date: Date) -> String {
        configureDateFormatter(for: date)
        return formatter.string(from: date)
    }
    
    func configureDateFormatter(for date: Date) {
        switch true {
        case Calendar.current.isDateInToday(date):
            formatter.dateFormat = "HH:mm"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
            formatter.dateFormat = "MM-dd HH:mm"
        case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
            formatter.dateFormat = "MM-dd HH:mm"
        default:
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
        }
    }
}

// MARK: - MessagesDisplayDelegate

extension EdlChatUIViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    // 气泡颜色
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.Hex(with: "FFFFFF") : UIColor.Hex(with: "333333")
    }
    // ???
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    // ???
//    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
//        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
//    }
    
    // MARK: - All Messages
    // ???
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.Hex(with: "6010FF") : UIColor.Hex(with: "FFFFFF")
    }
    // 气泡样式
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .topRight : .topLeft
        return .bubbleTail(tail, .pointedEdge)
    }
    // 头像
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if isFromCurrentSender(message: message) {
            let avatar = Avatar(image: avatarImage, initials: "e")
            avatarView.set(avatar: avatar)
        }else {
            let avatar = Avatar(image: #imageLiteral(resourceName: "kefuIcon"), initials: "e")
            avatarView.set(avatar: avatar)
        }
        
    }
    // 发送失败图标
    func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        // Cells are reused, so only add a button here once. For real use you would need to
        // ensure any subviews are removed if not needed
        accessoryView.subviews.forEach { $0.removeFromSuperview() }
        accessoryView.backgroundColor = .clear
        if sendMessageStatus == .sendMessageError {
            let button = UIButton(type: .custom)
            button.tintColor = .white
            button.setImage(#imageLiteral(resourceName: "fashibai"), for: .normal)
            button.frame = accessoryView.bounds
            button.isUserInteractionEnabled = false
            accessoryView.addSubview(button)
            accessoryView.layer.cornerRadius = accessoryView.frame.height / 2
        }
    }
    
    // 计算两个时间间隔
    func dateInterval(startTime:String,endTime:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let date1 = dateFormatter.date(from: startTime),
              let date2 = dateFormatter.date(from: endTime) else {
            return -1
        }
        let components = NSCalendar.current.dateComponents([.minute], from: date1, to: date2)
        //如果需要返回月份间隔，分钟间隔等等，只需要在dateComponents第一个参数后面加上相应的参数即可，示例如下：
    //    let components = NSCalendar.current.dateComponents([.month,.day,.hour,.minute], from: date1, to: date2)
        return components.minute!
    }

}

// MARK: - MessagesLayoutDelegate

extension EdlChatUIViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 15
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
}

