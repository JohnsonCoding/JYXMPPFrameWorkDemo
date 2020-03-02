//
//  ViewController.swift
//  JYXMPPFrameWorkDemo
//
//  Created by 江勇 on 2020/1/16.
//  Copyright © 2020 JohnsonCoding. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginAction(_ sender: Any) {
    
        UserDefaults.standard.set(userTextField.text, forKey: "imUsername")
        UserDefaults.standard.set(passwordTextField.text, forKey: "imPwd")
        UserDefaults.standard.synchronize()
        
        EdlXMPPManager.shareInstance.connect()
        let vc = EdlChatUIViewController()
        present(vc, animated: true, completion: nil)
    }
}

