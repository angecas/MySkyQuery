//
//  ToasterType.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 05/06/2025.
//

import UIKit

enum ToasterType {
    case informative
    case error

    var defaultTitle: String {
        switch self {
        case .informative: return NSLocalizedString("Info", comment: "")
        case .error: return NSLocalizedString("Error", comment: "")
        }
    }
    
    var defaultMessage: String {
        switch self {
        case .informative: return NSLocalizedString("Operation completed successfully.", comment: "")
        case .error: return NSLocalizedString("some_error", comment: "" )
        }
    }
}
