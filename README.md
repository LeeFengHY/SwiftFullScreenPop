# SwiftFullScreenPop

## 基于Swift3.0实现全屏侧滑返回

### Features
* 解决自定义navigationBar侧滑返回不能用快速帮你实现侧滑返回功能。
* 解决当某个界面navigationBar隐藏时下个界面有导航导致侧滑返回体验很差。
* 解决UIScrollView不能使用侧滑返回。

### How to use
`platform :ios, '7.0'`
```objc
target 'Your Project' do
    pod 'SwiftFullScreenPop', '~>1.0.0'
end
```
### Example
* 可以在自己的UINavigationController基类里面加入下面代码
```swift
 override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UINavigationController.swizzle()
        UIViewController.viewControllerSwizzle()
    }
```
* 在ViewController里面直接使用
```swift
// 不支持侧滑true
isInteractivePopDisable = true
// 隐藏当前页面导航
self.isPrefersNavigationBarHidden = true
```
### Swizzle
* 基于extension UInavigationController 和 extension UIViewController实现swizzle controller push function；viewWillAppear and ViewWillDisappear
```swift
DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UINavigationController.pushViewController(_:animated:))
            let swizzlerSelector = #selector(UINavigationController.myPushViewController(_:animated:))
            let originalMethod = class_getInstanceMethod(UINavigationController.self, originalSelector)
            let swizzlerMethod = class_getInstanceMethod(UINavigationController.self, swizzlerSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let isAddMethod = class_addMethod(UINavigationController.self, originalSelector, method_getImplementation(swizzlerMethod), method_getTypeEncoding(swizzlerMethod))
            if isAddMethod
            {
                class_replaceMethod(UINavigationController.self, swizzlerSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }else {
                method_exchangeImplementations(originalMethod, swizzlerMethod)
            }
        }
        
        DispatchQueue.once(token: Static.token) {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzlerSelector = #selector(UIViewController.myViewWillApper(_:))
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzlerMethod = class_getInstanceMethod(self, swizzlerSelector)
            let isAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzlerMethod), method_getTypeEncoding(swizzlerMethod))
            if isAddMethod
            {
                class_replaceMethod(self, swizzlerSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            }else {
                method_exchangeImplementations(originalMethod, swizzlerMethod)
            }
            
            let disappear_originalSEL = #selector(UIViewController.viewWillDisappear(_:))
            let disappear_swizzleSEL = #selector(UIViewController.myViewWillDisappear(_:))
            let disappear_originalMethod = class_getInstanceMethod(self, disappear_originalSEL)
            let disappear_swizzleMethod = class_getInstanceMethod(self, disappear_swizzleSEL)
            let isAdd: Bool = class_addMethod(self, disappear_originalSEL, method_getImplementation(disappear_swizzleMethod), method_getTypeEncoding(disappear_swizzleMethod))
            if isAdd {
                class_replaceMethod(self, disappear_swizzleSEL, method_getImplementation(disappear_originalMethod), method_getTypeEncoding(disappear_originalMethod))
            }else {
                 method_exchangeImplementations(disappear_originalMethod, disappear_swizzleMethod)
            }
        }
```
* 具体看本文Demo代码。
* 参考：[forkingdog](https://github.com/forkingdog/FDFullscreenPopGesture)

### 在实现cocoaPods遇到的坑
```objc
[!] The validator for Swift projects uses Swift 3.0 by default, if you are using a different version of swift you can use a `.swift-version` file to set the version for your Pod. For example to use Swift 2.3, run: 
    `echo "2.3" > .swift-version`. 
```
在终端里面执行：`echo "3.0" > .swift-version`
* 如果提示Authentication token is invalid or unverified. Either verify it with the email that was sent or register a new session.
重新在终端里面执行：`pod trunk register 邮箱名 “用户名”` 再到邮箱里面重新验证即可
* 如果想知道如何实现自己的代码用cocoapods管理可移动我的简书[文章](http://www.jianshu.com/p/756f36b2a672)

### 顺便提及下关于本地的代码如何git管理主要以下几步
1. git init.                 //当前需要提交的文件路径，和github上面XXXX.git一致
2. git add filename
3. git commit -m '提交信息说明' //添加描述
4. git pull //数据同步
5. git push origin master //提交数据
* 遇到如下错误
```objc
error: failed to push some refs to 'git@github.com:LeeFengHY/SwiftFullScreenPop.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.
```
是因为远程repository和我本地的repository冲突导致的，如下解决方法：
* 1:
`git pull origin master` <br>
`git push -u origin master`
* 2:若不想merge远程和本地修改，可以先创建新的分支：<br>
`git branch [name]` <br>
`git push -u origin [name]`
### 联系
* 留言或者加我QQ：578545715
        
