//
//  SearchViewModel.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import Combine
import Foundation
import SwiftUI

protocol SearchViewModelDelegate: AnyObject {
    func viewModel(_: SearchViewModel, didUpdateParameters isUpdated: Bool)
}

final class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    private var cancellables = Set<AnyCancellable>()
    private var flights: FlightSearchResponse?

    @Published private(set) var arrivalStations: [Station] = []
    @Published private(set) var departureStations: [Station] = []
    @Published private(set) var error: Bool = false
    @Published private(set) var parameters = FlightSearchParameters()
            
    private let flightsDataSource: FlightDataSourceProtocol
    
    init(flightsDataSource: FlightDataSourceProtocol) {
        self.flightsDataSource = flightsDataSource
    }
    
    func fetchStations() async throws {
        departureStations = try await flightsDataSource.getStations().stations
        arrivalStations = departureStations
    }

    func fetchFlights() async throws -> FlightSearchResponse {
        let flights = try await flightsDataSource.getFlights(with: parameters)
        self.flights = flights
        return flights
    }

    func filteredDepartureStations(for searchText: String?) -> [Station] {
        guard let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            return departureStations
        }

        return departureStations.filter {
            ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.code?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    func filteredArrivalStations(for searchText: String?) -> [Station] {
        guard let searchText = searchText?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty else {
            return arrivalStations
        }

        return arrivalStations.filter {
            ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.code?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    func setDepartureStation(_ station: Station) -> Bool {
        if station == parameters.destination {
            delegate?.viewModel(self, didUpdateParameters: station == parameters.destination)
            return false
        }
        
        parameters.origin = station
        return true
    }
    
    func setArrivalStation(_ station: Station) -> Bool{
        if station == parameters.origin {
            delegate?.viewModel(self, didUpdateParameters: station == parameters.destination)
            return false
        }
        
        parameters.destination = station
        return true
    }
    
    func setDepartureDate(_ stringDate: String) {
        parameters.dateOut = stringDate
    }
    
    func searchButtonIsEnabled() -> Bool {
        return parameters.origin != nil &&
               parameters.destination != nil &&
               !parameters.dateOut.isEmptyOrNil &&
               (parameters.adults ?? 0) >= 1
    }
    
    func setAdults(adults: Int) {
        parameters.adults = adults
    }
    
    func setTeenagers(teenagers: Int) {
        parameters.teens = teenagers
    }

    func setChildren(children: Int) {
        parameters.children = children
    }
    
    func switchOriginAndDestination() {
        let destination = parameters.destination
        let arrival = parameters.origin
        
        parameters.origin = destination
        parameters.destination = arrival
    }
    
    func clearParameters() {
        parameters = FlightSearchParameters()
    }
}
