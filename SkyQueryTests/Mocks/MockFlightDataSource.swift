//
//  MockFlightDataSource.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 10/06/2025.
//

import XCTest
@testable import SkyQuery

final class MockFlightDataSource: FlightDataSourceProtocol {
    var stationsToReturn: [Station] = []
    var flightsToReturn: FlightSearchResponse?

    func getStations() async throws -> StationResponse {
        return StationResponse(stations: stationsToReturn)
    }

    func getFlights(with parameters: FlightSearchParameters) async throws -> FlightSearchResponse {
        guard let flights = flightsToReturn else {
            throw NSError(domain: "No flights", code: 0)
        }
        return flights
    }
}
