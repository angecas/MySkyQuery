//
//  FlightServiceProtocol.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import Foundation

// MARK: - Flight Service Protocol
protocol FlightServiceProtocol {
    func getStations() async throws -> StationResponse
    func getFlights(with parameters: FlightSearchParameters) async throws -> FlightSearchResponse
}

// MARK: - Flight Service Implementation
final class FlightService: FlightServiceProtocol {
    private let client: APIClientProtocol
    
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func getStations() async throws -> StationResponse {
        try await client.performRequest(StationsEndpoint.getStations)
    }
    
    func getFlights(with parameters: FlightSearchParameters) async throws -> FlightSearchResponse {
        try await client.performRequest(FlightsEndpoint.searchFlights(parameters))
    }
}
