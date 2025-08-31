//
//  SearchFactory.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 06/06/2025.
//

import UIKit

enum SearchFactory {
    static func makeSearchScreen(coordinator: SearchCoordinatorProtocol) -> UIViewController {
        let flightService = FlightService()
        let flightsDataSource = FlightsDataSource(flightService: flightService)
        let viewModel = SearchViewModel(flightsDataSource: flightsDataSource)
        let viewController = SearchViewController(viewModel: viewModel, coordinator: coordinator)
        return viewController
    }
}
