# JYXMPPFrameWorkDemo
后台openfire搭建服务,iOS端XMPPFramework实现客服聊天功能,MessageKit搭建聊天界面UI

## 下载spark客户端可以登录对方账号进行测试
![image](https://github.com/JohnsonCoding/JYXMPPFrameWorkDemo/blob/master/spark.png)

## 效果图 (左边为spark客户端界面,右边为项目的聊天界面)
![JYXMPPFrameWorkDemo.gif](https://github.com/JohnsonCoding/JYXMPPFrameWorkDemo/blob/master/IM效果图.gif)

## 使用
1. 将 JYXMPPFramework文件夹添加(拖放)到你的工程

2. 启动聊天室,进入聊天页面
````
EdlXMPPManager.shareInstance.connect()
   let vc = EdlChatUIViewController()
   present(vc, animated: true, completion: nil)
````
   
3. 需要修改成自己的参数的配置有
````
KHostDomain,KHostName,KHostPort,KResource,KImSupport,账号(imUsername)密码(imPwd)
````

## 题外
(聊天UI界面借用MessageKit库,如果有需要修改样式,了解相关属性请前往查看[MessageKit](https://github.com/MessageKit/MessageKit).)~ ~

## 系统要求
该库最低支持 `iOS 9.0`

## 许可证
LEETheme 使用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。

