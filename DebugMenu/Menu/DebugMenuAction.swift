//
//  DebugMenuAction.swift
//
//  Created by Renaud Cousin on 3/3/21.
//

import Foundation
import UIKit

public typealias DebugMenuActionHandler = () -> Void
public typealias DebugMenuSelectionHandler = () -> Bool
public struct DebugMenuAction {
    public let icon: UIImage?
    public let label: String
    public let tintColor: UIColor
    public let backgroundColor: UIColor
    public let action: DebugMenuActionHandler
    public let selectionHandler: DebugMenuSelectionHandler

    public init(systemImageName: String,
                label: String,
                tintColor: UIColor = .white,
                backgroundColor: UIColor = UIColor.systemBlue,
                action: @escaping DebugMenuActionHandler,
                selectionHandler: DebugMenuSelectionHandler? = nil) {
        self.icon = UIImage(systemName: systemImageName)
        self.label = label
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.action = action
        self.selectionHandler = selectionHandler ?? { false }
    }
}
