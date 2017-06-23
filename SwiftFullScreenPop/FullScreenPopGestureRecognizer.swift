
import Foundation
import UIKit

class _fullscreenPopgestureRecognizerDelegate: NSObject,UIGestureRecognizerDelegate,UINavigationControllerDelegate {
    public var navgationController: UINavigationController?
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.navgationController?.viewControllers.count)! <= 1 {
            return false
        }
        let topViewController = self.navgationController?.viewControllers.last
        if topViewController?.isInteractivePopDisable == true {
            return false
        }
        let translation = gestureRecognizer.location(in: gestureRecognizer.view)
        if translation.x <= 0{
            return false
        }
        return true
    }
}

extension UINavigationController
{
    struct AssociatedKey {
        static let popgesture = UnsafeRawPointer.init(bitPattern: "popgesture".hash)
        static let navigationBarAppearanceEnabled = UnsafeRawPointer.init(bitPattern: "navigationBarAppearanceEnabled".hash)
        static let fullsreenDelegate = UnsafeRawPointer.init(bitPattern: "fullsreenDelegate".hash)
    }
    
    // readonly-自定义侧滑返回手势
    var fullscrrenPopGestureRecognizer:UIPanGestureRecognizer {
        get {
            var panGestureRecognizer = objc_getAssociatedObject(self, AssociatedKey.popgesture) as? UIPanGestureRecognizer
            if panGestureRecognizer == nil {
                panGestureRecognizer = UIPanGestureRecognizer.init()
                panGestureRecognizer?.maximumNumberOfTouches = 1
                objc_setAssociatedObject(self, AssociatedKey.popgesture, panGestureRecognizer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return panGestureRecognizer!
        }
    }
    //
    public var viewControllerBaseNavigationBarAppearanceEnabled: Bool
    {
        get {
            let number = objc_getAssociatedObject(self, AssociatedKey.navigationBarAppearanceEnabled) as? Bool
            if number != nil {
                return number!
            }
            self.viewControllerBaseNavigationBarAppearanceEnabled = true
            return true
        }
        set {
            objc_setAssociatedObject(self, AssociatedKey.navigationBarAppearanceEnabled, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    // 侧滑返回手势代理
    var popGestureRecognizerDelegate: _fullscreenPopgestureRecognizerDelegate?
    {
        var delegate = objc_getAssociatedObject(self, AssociatedKey.fullsreenDelegate) as? _fullscreenPopgestureRecognizerDelegate
        if delegate == nil {
            delegate = _fullscreenPopgestureRecognizerDelegate.init()
            delegate?.navgationController = self
            objc_setAssociatedObject(self, AssociatedKey.fullsreenDelegate, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return delegate
    }
  
    class public func swizzle()
    {
        struct Static {
            static var token = "token-navgationController"
        }
        
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
        UIViewController.viewControllerSwizzle()
    }

    // 自定义push viewController method
    func myPushViewController(_ viewController: UIViewController, animated: Bool)
    {
        let gesture = self.interactivePopGestureRecognizer
        if self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.fullscrrenPopGestureRecognizer) == false && gesture != nil {
            self.interactivePopGestureRecognizer?.view?.addGestureRecognizer(self.fullscrrenPopGestureRecognizer)
            let target = gesture?.delegate
            let action = Selector.init(("handleNavigationTransition:"))
            self.fullscrrenPopGestureRecognizer.delegate = self.popGestureRecognizerDelegate
            self.fullscrrenPopGestureRecognizer.addTarget(target!, action: action)
            //禁用系统的全屏返回
            self.interactivePopGestureRecognizer?.isEnabled = false
        }
        setupViewControllerBasedNavigationBarAppearanceIfNeed(viewController)
        self.myPushViewController(viewController, animated: animated)
    }
    // 设置viewController和appear viewController是否隐藏导航
    private func setupViewControllerBasedNavigationBarAppearanceIfNeed(_ appearingViewController: UIViewController)
    {
        if self.viewControllerBaseNavigationBarAppearanceEnabled == false {
            return
        }
        //weak var weakSelf = self
        let block: ViewControllerWillAppearInjectBlock = {[weak self] (viewController: UIViewController, animated: Bool)  in
            self!.setNavigationBarHidden(viewController.isPrefersNavigationBarHidden, animated: animated)
        }
        appearingViewController.willAppearInjectBlock = block
        let disappearingViewController = self.viewControllers.last
        if disappearingViewController != nil && disappearingViewController?.willAppearInjectBlock == nil {
            disappearingViewController?.willAppearInjectBlock = block
        }
    }
}

typealias ViewControllerWillAppearInjectBlock = (_ viewController: UIViewController, _ animated: Bool) -> Void
extension UIViewController
{
    class fileprivate func viewControllerSwizzle()
    {
        struct Static {
            static var token = "token-viewController"
        }
        // make sure this isn't a subclass
        if self !== UIViewController.self {
            return
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
    }

    func myViewWillDisappear(_ animated: Bool)  {
        weak var weakself = self
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 0)) {
            let viewController = weakself?.navigationController?.viewControllers.last
            if (viewController != nil) && viewController?.isPrefersNavigationBarHidden == false {
                weakself?.navigationController?.navigationBar.isHidden = false
            }
        }
        self.myViewWillDisappear(animated)
    }
    func myViewWillApper(_ animated: Bool)
    {
        if willAppearInjectBlock != nil {
            willAppearInjectBlock!(self, animated)
        }
        self.myViewWillApper(animated)
    }
    
    var willAppearInjectBlock: ViewControllerWillAppearInjectBlock? {
        get {
            let willAppearInjectBlock = objc_getAssociatedObject(self, AssociatedKey.willAppearInjectBlock) as? ViewControllerWillAppearInjectBlock
            return willAppearInjectBlock
        }
        set {
            objc_setAssociatedObject(self, AssociatedKey.willAppearInjectBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    struct AssociatedKey {
        static let interactivePopDisable = UnsafeRawPointer.init(bitPattern: "interactivePopDisable".hash)
        static let navgationBarHidden = UnsafeRawPointer.init(bitPattern: "navgationBarHidden".hash)
        static let willAppearInjectBlock = UnsafeRawPointer.init(bitPattern: "willAppearInjectBlock".hash)
    }
    // 取消侧滑 default is false, true为不支持侧滑返回
    public var isInteractivePopDisable: Bool
    {
        get {
            let interactivePopDisable = objc_getAssociatedObject(self, AssociatedKey.interactivePopDisable) as? Bool
            return interactivePopDisable ?? false
        }
        set {
            objc_setAssociatedObject(self, AssociatedKey.interactivePopDisable, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    // default is false navgationBar doesn't hid, if true the navgationBar is hidden
    public var isPrefersNavigationBarHidden: Bool
    {
        get {
            let prefersNavigationBarHidden = objc_getAssociatedObject(self, AssociatedKey.navgationBarHidden) as? Bool
            return prefersNavigationBarHidden ?? false
        }
        set {
            objc_setAssociatedObject(self, AssociatedKey.navgationBarHidden, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
}

extension DispatchQueue
{
    fileprivate static var onceToken = [String]()
    open class func once(token: String, block:()-> Void)
    {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if onceToken.contains(token) {
            return
        }
        onceToken.append(token)
        block()
    }
}
// 解决UIScrollView上滑动手势冲突问题
extension UIScrollView: UIGestureRecognizerDelegate
{
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.contentOffset.x <= 0 {
            if (otherGestureRecognizer.delegate?.isKind(of: _fullscreenPopgestureRecognizerDelegate.classForCoder()))! {
                return true
            }
        }
        return false
    }
    
}
