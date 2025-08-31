//
//  ResultFactory.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 08/06/2025.
//
import UIKit

enum ResultFactory {
    static func makeResultsScreen(flights: FlightSearchResponse?, coordinator: ResultsCoordinatorProtocol) -> UIViewController {
        let flightService = FlightService()
        let flightsDataSource = FlightsDataSource(flightService: flightService)
        let viewModel = ResultsViewModel(flights: flights, flightsDataSource: flightsDataSource)
        let viewController = ResultsViewController(viewModel: viewModel, coordinator: coordinator)
        return viewController
    }
}
