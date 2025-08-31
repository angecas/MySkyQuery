//
//  ResultsViewModel.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import Combine
import Foundation

final class ResultsViewModel {
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var flights: [Trip]?
    private(set) var currency: String

    private let flightsDataSource: FlightDataSourceProtocol

    init(flights: FlightSearchResponse?, flightsDataSource: FlightDataSourceProtocol) {
        self.flights = flights?.trips
        self.currency = flights?.currency ?? "EUR"
        self.flightsDataSource = flightsDataSource
    }
}
