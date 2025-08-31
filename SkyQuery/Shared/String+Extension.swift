//
//  test.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 08/06/2025.
//

import UIKit
extension Optional where Wrapped == String {
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}

extension String {
    func extractTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "h:mm a"
            return formatter.string(from: date)
        }
        return self 
    }
    
    func extractDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
        return self
    }

}
