import UIKit

/// 状态栏高度
let kStatusBarHeight: CGFloat = ((UIApplication.shared.statusBarFrame.height == 0) ? (isIphoneX ? 44.0 : 20.0) : (UIApplication.shared.statusBarFrame.height))

/// 导航栏高度
let kNavigationBarHeight: CGFloat = (kStatusBarHeight + 44.0)

/// 通话时，热点状态栏高度
let kHotPointStatusBarHeight: CGFloat = (kStatusBarHeight + 20.0)

/// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height

/// 屏幕Size
let kScreenSize = UIScreen.main.bounds.size

/// Tabbar高度
let kTabBarHeight: CGFloat = (isIphoneX ? 83.0 : 49.0)

/// 安全区域顶部高度 == 状态栏高度
let kSafeAreaTopHeight = (kStatusBarHeight)

/// 安全区域顶部位移 == IphoneX状态栏高度变化
let kSafeAreaTopMargin: CGFloat = (isIphoneX ? 24.0 : 0.0)

/// 安全区域底部间隙 == 底部进入主屏幕手势标识高度
let kSafeAreaBottomHeight: CGFloat = (isIphoneX ? 34.0 : 0.0)

/// 屏幕宽（安全区域）
let kSafeAreaWidth = (isPortrait ? kScreenWidth : (kScreenWidth - kSafeAreaBottomHeight))

/// 屏幕高（安全区域）未加上(导航栏高度)及(底部栏高度)
let kSafeAreaHeight = (kScreenHeight - kSafeAreaTopHeight - kSafeAreaBottomHeight)

/// 是否竖屏模式
let isPortrait = (UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown)

/// 是否iOS10
let laterThanIOS10 = (Float(UIDevice.current.systemVersion)! >= 10.0)

/// 是否iOS11
let laterThanIOS11 = (Float(UIDevice.current.systemVersion)! >= 11.0)

/// 屏幕缩放比例
let kScreenScale = UIScreen.main.scale

/// iPhoneX
let isIphoneX = ((kScreenWidth == 375) && (kScreenHeight == 812))

