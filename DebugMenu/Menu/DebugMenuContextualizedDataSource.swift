//
//  DebugMenuContextualizedDataSource.swift
//
//  Created by Renaud Cousin on 3/3/21.
//

import Foundation

public protocol DebugMenuContextualizedDataSource {
    var menuActions: [DebugMenuSection] { get }
}
