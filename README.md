# JYXMPPFrameWorkDemo
后台openfire搭建服务,iOS端XMPPFramework实现客服聊天功能,MessageKit搭建聊天界面UI

## 效果图
![DialogTypeNornal.gif](https://upload-images.jianshu.io/upload_images/9163368-ca5125e911b98558.gif?imageMogr2/auto-orient/strip)

### 使用
1. 将 JYXMPPFramework文件夹添加(拖放)到你的工程。
2. 启动聊天室,进入聊天页面
   EdlXMPPManager.shareInstance.connect()
   let vc = EdlChatUIViewController()
   present(vc, animated: true, completion: nil)
3. 需要修改成自己的参数的配置有KHostDomain,KHostName,KHostPort,KResource,KImSupport,账号(imUsername)密码(imPwd)

题外
==============
(聊天UI界面借用MessageKit库,如果有需要修改样式,了解相关属性请前往查看[MessageKit](https://github.com/MessageKit/MessageKit).)~ ~

系统要求
==============
该库最低支持 `iOS 9.0`

许可证
==============
LEETheme 使用 MIT 许可证，详情见 [LICENSE](LICENSE) 文件。

