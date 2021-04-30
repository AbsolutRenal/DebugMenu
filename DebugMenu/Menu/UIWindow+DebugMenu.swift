// 
//  UIWindow+DebugMenu.swift
//
//  Created by Renaud Cousin on 3/3/21.
//


import Foundation
import UIKit

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            displayDebugMenu()
        }
    }

    private func displayDebugMenu() {
        DebugMenu.shared.toggleDisplay()
    }
}
