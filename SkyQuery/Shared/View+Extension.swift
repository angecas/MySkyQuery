//
//  View+Extension.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import Foundation
import SwiftUI

extension View {
    func asUIView() -> UIView {
        let controller = UIHostingController(rootView: self)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller.view
    }
}
