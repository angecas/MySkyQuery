//
//  AppCoordinator.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit

class AppCoordinator: Coordinator {
    var loadingOverlay: UIView?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        childCoordinators.append(searchCoordinator)
        searchCoordinator.start()
    }
}
