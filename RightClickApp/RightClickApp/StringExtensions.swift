//
//  StringExtensions.swift
//  RightClickApp
//
//  Created by Janidu Wanigasuriya on 27/03/2016.
//  Copyright © 2016 Right Click. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }
}