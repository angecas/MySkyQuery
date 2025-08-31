//
//  ResultsCoordinator.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit


protocol ResultsCoordinatorProtocol: AnyObject {
    func showDetails()
}

class ResultsCoordinator: ResultsCoordinatorProtocol, Coordinator {
    var loadingOverlay: UIView?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //TODO: look at this
    func start(with flights: FlightSearchResponse?) {
            let resultsViewController = ResultFactory.makeResultsScreen(flights: flights, coordinator: self)
            resultsViewController.title = NSLocalizedString("available_flights", comment: "")
            self.navigationController.pushViewController(resultsViewController, animated: false)
    }
    
    func showDetails() {
    }
}
