// 
//  DebugMenu.swift
//
//  Created by Renaud Cousin on 3/3/21.
//


import Foundation
import UIKit

final class DebugMenu {
    static var shared: DebugMenu = DebugMenu()

    private var isDisplayed: Bool = false {
        didSet {
            if isDisplayed {
                var contextualizedActions: [DebugMenuSection] = []
                if let controller = UIViewController.getAppTopViewController(parseChildren: true) as? DebugMenuContextualizedDataSource {
                    contextualizedActions = controller.menuActions
                }
                window.makeKeyAndVisible()
                debugMenuController.contextualizedMenuActions = contextualizedActions
                debugMenuController.reload()
            }
            debugMenuController.toggleDisplay(isDisplayed) { [unowned self] in
                if !self.isDisplayed {
                    self.window.isHidden = true
                }
            }
        }
    }

    private lazy var debugMenuController: DebugMenuViewController = {
        return DebugMenuViewController()
    }()

    private lazy var window: UIWindow = {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            let screenBounds = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.frame ?? .zero
            let window = UIWindow(frame: screenBounds)
            return window
        }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = debugMenuController
        window.makeKeyAndVisible()
        return window
    }()

    private init() {}

    func toggleDisplay() {
        isDisplayed.toggle()
    }
}

fileprivate extension UIViewController {
    class func getAppTopViewController(parseChildren: Bool) -> UIViewController? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController?.getTopViewController(parseChildren: parseChildren)
    }

    func getTopViewController(parseChildren: Bool = false) -> UIViewController {
        if let presentedViewController = self.presentedViewController {
            if let navController = presentedViewController as? UINavigationController {
                if let lastViewController = navController.viewControllers.last {
                    return lastViewController.getTopViewController(parseChildren: parseChildren)
                }
            }

            return presentedViewController.getTopViewController(parseChildren: parseChildren)
        } else if parseChildren,
                  let child = children.last {
            return child.getTopViewController(parseChildren: parseChildren)
        }

        return self
    }
}
