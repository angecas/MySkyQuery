//
//  MarvelDataSource.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 05/06/2025.
//

import Foundation

// MARK: - Flight Data Source Protocol
protocol FlightDataSourceProtocol {
    func getStations() async throws -> StationResponse
    func getFlights(with parameters: FlightSearchParameters) async throws -> FlightSearchResponse
}

// MARK: - Flight Data Source Implementation
final class FlightsDataSource: FlightDataSourceProtocol {
    private let flightService: FlightServiceProtocol
    private let cache = DiskCache<StationResponse>(fileName: "stations.json")

    init(flightService: FlightServiceProtocol = FlightService()) {
        self.flightService = flightService
    }

    func getStations() async throws -> StationResponse {
        if let cached = try? cache.load() {
            return cached
        }

        let stations = try await flightService.getStations()
        try? cache.save(stations)
        return stations
    }

    func getFlights(with parameters: FlightSearchParameters) async throws -> FlightSearchResponse {
        return try await flightService.getFlights(with: parameters)
    }
}
