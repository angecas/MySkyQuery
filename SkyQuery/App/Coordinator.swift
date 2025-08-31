//
//  CoordinatorFinishDelegate.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var loadingOverlay: UIView? { get set }

    func start()
    func showToaster(_ message: String?, toasterType: ToasterType)
    func showLoading()
    func hideLoading()
}

extension Coordinator {
    func start() {}
    
    func showToaster(_ message: String? = nil, toasterType: ToasterType = .error) {
        let message = message ?? toasterType.defaultMessage
        let alertController = UIAlertController(
            title: toasterType.defaultTitle,
            message: message,
            preferredStyle: .alert
        )

        DispatchQueue.main.async {
            self.navigationController.present(alertController, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                alertController.dismiss(animated: true)
            }
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard self.loadingOverlay == nil else { return }
            guard let view = self.navigationController.view else { return }

            let overlay = UIView()
            overlay.translatesAutoresizingMaskIntoConstraints = false
            overlay.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()

            overlay.addSubview(spinner)
            view.addSubview(overlay)

            NSLayoutConstraint.activate([
                overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                overlay.topAnchor.constraint(equalTo: view.topAnchor),
                overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                spinner.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                spinner.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
            ])

            self.loadingOverlay = overlay
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingOverlay?.removeFromSuperview()
            self?.loadingOverlay = nil
        }
    }
}
