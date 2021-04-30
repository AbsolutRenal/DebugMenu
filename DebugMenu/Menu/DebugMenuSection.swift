//
//  DebugMenuSection.swift
//
//  Created by Renaud Cousin on 3/3/21.
//

import Foundation

public struct DebugMenuSection {
    public let title: String
    public let actions: [DebugMenuAction]

    public init(title: String,
                actions: [DebugMenuAction]) {
        self.title = title
        self.actions = actions
    }
}
