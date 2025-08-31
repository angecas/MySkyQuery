//
//  SearchCoordinator.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit

protocol SearchCoordinatorProtocol: Coordinator, AnyObject {
    var delegate: SearchCoordinatorDelegate? { get set }
    func showResults(flights: FlightSearchResponse?)
    func updateClearButtonColor(hasParameters: Bool)
    func start()
}

protocol SearchCoordinatorDelegate: AnyObject {
    func didTapCleanParameters()
}

class SearchCoordinator: SearchCoordinatorProtocol, Coordinator {
    var loadingOverlay: UIView?
    
    weak var delegate: SearchCoordinatorDelegate?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var resultsCoordinator: ResultsCoordinator?
    private var clearButtonItem: UIBarButtonItem?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchViewController = SearchFactory.makeSearchScreen(coordinator: self)
        searchViewController.title = "Search Flight"
        
        let searchItem = UIBarButtonItem(
            title: "Clear",
            style: .plain,
            target: self,
            action: #selector(didTapCleanParameters)
        )
        searchItem.tintColor = .gray
        searchItem.isEnabled = false
        clearButtonItem = searchItem
        searchViewController.navigationItem.rightBarButtonItem = searchItem
        
        navigationController.pushViewController(searchViewController, animated: false)
    }
    
    func showResults(flights: FlightSearchResponse?) {
        let resultsCoordinator = ResultsCoordinator(navigationController: navigationController)
        self.resultsCoordinator = resultsCoordinator
        childCoordinators.append(resultsCoordinator)

        resultsCoordinator.start(with: flights)
    }
    
    @objc private func didTapCleanParameters() {
        delegate?.didTapCleanParameters()
    }
    
    func updateClearButtonColor(hasParameters: Bool = false) {
        clearButtonItem?.isEnabled = hasParameters
        clearButtonItem?.tintColor = hasParameters ? .white : .gray
    }
}
