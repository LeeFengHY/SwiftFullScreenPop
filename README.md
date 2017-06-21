# SwiftFullScreenPop

基于Swift3.0实现全屏侧滑返回

### features
* 解决自定义navigationBar侧滑返回失效的时候快速帮你实现侧滑返回功能。
* 解决当某个界面navigationBar隐藏时下个界面有导航导致侧滑返回体验很差。
* 解决UIScrollView不能使用侧滑返回。

### Usage
`platform :ios, '7.0'`
```swift
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
* 具体看Demo代码。参考：[forkingdog](https://github.com/forkingdog/FDFullscreenPopGesture)

### 在实现cocoaPods遇到的坑

        
        
        
