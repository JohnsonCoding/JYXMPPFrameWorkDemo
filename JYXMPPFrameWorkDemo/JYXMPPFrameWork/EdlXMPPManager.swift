//
//  EdlXMPPManager.swift
//  ClubWin
//
//  Created by 江勇 on 2019/12/10.
//  Copyright © 2019 edaili. All rights reserved.
//

import UIKit
import XMPPFramework


let KHostDomain = "izuf64jq4bbagoh6cy0x9iz"
let KHostName = "47.103.144.208"
let KHostPort = 5222
let KResource = "iOS"

protocol MessagingDelegate {
    func messageReceived(message: XMPPMessage)
    func messageSent(message: XMPPMessage)
}

class EdlXMPPManager: NSObject {
    
    static let shareInstance = EdlXMPPManager()
    
    var messagingDelegate: MessagingDelegate?
    
    var didReceiveMessageBlock: ((XMPPMessage) -> Void)?
    
    //数据流
    var xmppStream : XMPPStream?
    
    func removeSource() {
        // 移除代理
        xmppStream?.removeDelegate(self)
        // 断开连接
        disconnect()
        // 清空资源
        xmppStream = nil
    }
    
    func setupXMPPStream() {
        //初始化
        xmppStream = XMPPStream()
        xmppStream?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }

    // 连接到服务成功后，再发送密码授权
    func sendPwdToHost() {
        do {
            let imPwd = UserDefaults.standard.string(forKey: "imPwd") ?? ""
            try xmppStream?.authenticate(withPassword: imPwd)
            print("密码授权成功")
        } catch {
            print("密码授权失败")
        }
    }
    
    // 授权成功后，发送"在线"消息
    private func goOnline() {
        print("发送 在线 消息")
        let presence = XMPPPresence()
        xmppStream?.send(presence)
    }

    private func goOffline() {
        let presence = XMPPPresence(type: "unavailable")
        xmppStream?.send(presence)
    }

    func connect() {
        if !(xmppStream?.isConnected ?? false) {
           setupXMPPStream()
        }
        let imUsername = UserDefaults.standard.string(forKey: "imUsername")
        let myJID = XMPPJID(user: imUsername, domain: KHostDomain, resource: KResource)
        xmppStream?.myJID = myJID
        xmppStream?.hostName = KHostName
        xmppStream?.hostPort = UInt16(KHostPort)
        
        do {
            try xmppStream?.connect(withTimeout: XMPPStreamTimeoutNone)
            print("Connection success")
        } catch {
            print("Something went wrong!")
        }
    }
    
    func disconnect() {
        goOffline()
        xmppStream?.disconnect()
    }
}
// MARK: --XMPPStream的代理
extension EdlXMPPManager: XMPPStreamDelegate {
    //与主机连接成功
    func xmppStreamDidConnect(_ sender: XMPPStream) {
        print("与主机连接成功")
        self.sendPwdToHost()
    }
    // 与主机断开连接
    func xmppStreamDidDisconnect(_ sender: XMPPStream, withError error: Error?) {
        // 如果有错误，代表连接失败
        // 如果没有错误，表示正常的断开连接(人为断开连接)
        print("与主机断开连接")
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        print("授权成功")
        goOnline()
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive iq: XMPPIQ) -> Bool {
        print("Did receive IQ")
        return false
    }

    func xmppStream(_ sender: XMPPStream, didReceive presence: XMPPPresence) {
        //presence.from 消息是谁发送过来 XMPPPresence 在线 离线
        print("好友的在线状态 \(String(describing: presence.from))")
    }
    
    func xmppStream(_ sender: XMPPStream, didReceive message: XMPPMessage) {
        print("接收到好友消息 \(message)")
        messagingDelegate?.messageReceived(message: message)
    }
    
    func xmppStream(_ sender: XMPPStream, didSend message: XMPPMessage) {
        print("本人发送出去的消息 \(message)")
        messagingDelegate?.messageSent(message: message)
    }
    
}
