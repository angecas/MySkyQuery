//
//  HostingView.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 10/06/2025.
//

import SwiftUI
import UIKit

class HostingView<Content: View>: UIView {
    private var hostingController: UIHostingController<Content>?
    
    var rootView: Content {
        didSet {
            updateHostingController()
        }
    }
    
    init(rootView: Content) {
        self.rootView = rootView
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        updateHostingController()
    }
    
    private func updateHostingController() {
        // Remove old hosting controller
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()
        
        // Create new hosting controller
        let controller = UIHostingController(rootView: rootView)
        controller.view.backgroundColor = .clear
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Add to view hierarchy
        addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: topAnchor),
            controller.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        hostingController = controller
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hostingController?.view.invalidateIntrinsicContentSize()
        hostingController?.view.layoutIfNeeded()
    }
}
