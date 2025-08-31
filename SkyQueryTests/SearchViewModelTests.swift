//
//  SkyQueryTests.swift
//  SkyQueryTests
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import XCTest
@testable import SkyQuery

final class SearchViewModelTests: XCTestCase {
    var viewModel: SearchViewModel!
    var mockDataSource: FlightDataSourceProtocol!

    override func setUpWithError() throws {
        mockDataSource = MockFlightDataSource()
        viewModel = SearchViewModel(flightsDataSource: mockDataSource)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockDataSource = nil
    }
    
    func testFilterStationsWithText() async throws {
        let stationsResponse = try MockHelper.loadMockFromJSON(named: "StationsResponse", responseType: StationResponse.self, for: SearchViewModelTests.self)
        let mockDataSource = MockFlightDataSource()
        let stations = stationsResponse.stations
        mockDataSource.stationsToReturn = stations
        viewModel = SearchViewModel(flightsDataSource: mockDataSource)
        
        try await viewModel.fetchStations()
        
        let filteredStations = viewModel.filteredArrivalStations(for: "ABZ")
        XCTAssertTrue(stations.count >= filteredStations.count)
        
        guard filteredStations.contains(where: { $0.code?.localizedCaseInsensitiveContains("ABZ") == true }) else {
            XCTFail("Did not filter correctly")
            return
        }
    }

    func testSetFlightParameters() async throws {
        let stations = try MockHelper.loadMockFromJSON(named: "Stations", responseType: Stations.self, for: SearchViewModelTests.self)

        guard let selectedStation = stations.first else {
            XCTFail( "Failed to load mock" )
            return
        }

        let departSelection = viewModel.setDepartureStation(selectedStation)
        XCTAssertTrue(departSelection)
        XCTAssertEqual(viewModel.parameters.origin, selectedStation)
        
        let arrivalSelection = viewModel.setArrivalStation(selectedStation)
        XCTAssertNotEqual(viewModel.parameters.destination, selectedStation)

        XCTAssertFalse(arrivalSelection)
    }

    func testSwapOriginAndDestination() async throws {
        let stations = try MockHelper.loadMockFromJSON(named: "Stations", responseType: [Station].self, for: SearchViewModelTests.self)

        guard let originStation = stations.first, let destinationStation = stations.last else {
            XCTFail( "Failed to load mock" )
            return
        }
        
        _ = viewModel.setArrivalStation(originStation)
        _ = viewModel.setDepartureStation(destinationStation)
        
        XCTAssertTrue(viewModel.parameters.hasParameters)
        XCTAssertEqual(viewModel.parameters.destination, originStation)
        XCTAssertEqual(viewModel.parameters.origin, destinationStation)

        viewModel.switchOriginAndDestination()
        
        XCTAssertEqual(viewModel.parameters.destination, destinationStation)
        XCTAssertEqual(viewModel.parameters.origin, originStation)
    }

    func testClearParameters() async throws {
        let stations = try MockHelper.loadMockFromJSON(named: "Stations", responseType: [Station].self, for: SearchViewModelTests.self)
        
        guard let station = stations.first, let otherStation = stations.last else {
            XCTFail( "Failed to load mock" )
            return
        }
        
        _ = viewModel.setArrivalStation(station)
        _ = viewModel.setDepartureStation(otherStation)
        viewModel.setTeenagers(teenagers: 2)
        viewModel.setAdults(adults: 6)
        
        XCTAssertTrue(viewModel.parameters.hasParameters)

        viewModel.clearParameters()
        
        XCTAssertFalse(viewModel.parameters.hasParameters)
        XCTAssertNil(viewModel.parameters.origin)
        XCTAssertNil(viewModel.parameters.destination)
        XCTAssertEqual(viewModel.parameters.adults, 1)
        XCTAssertNil(viewModel.parameters.teens)
        XCTAssertNil(viewModel.parameters.children)
        XCTAssertNil(viewModel.parameters.dateOut)
    }
    
    func testFetchStationsAndPopulatesDepartureAndArrivalStations() async throws {

        let stations = try MockHelper.loadMockFromJSON(named: "StationsResponse", responseType: StationResponse.self, for: SearchViewModelTests.self)
        let mockDataSource = MockFlightDataSource()
        mockDataSource.stationsToReturn = stations.stations
        viewModel = SearchViewModel(flightsDataSource: mockDataSource)
        
        try await viewModel.fetchStations()
        
        XCTAssertEqual(viewModel.departureStations, stations.stations)
        XCTAssertEqual(viewModel.arrivalStations, stations.stations)
    }
    
    func testFetchFlightsReturnsExpectedResponse() async throws {
        let expectedResponse = try MockHelper.loadMockFromJSON(
            named: "FlightSearchResponse",
            responseType: FlightSearchResponse.self,
            for: SearchViewModelTests.self
        )
        
        let mockDataSource = MockFlightDataSource()
        mockDataSource.flightsToReturn = expectedResponse
        viewModel = SearchViewModel(flightsDataSource: mockDataSource)
        
        let response = try await viewModel.fetchFlights()
        
        XCTAssertNotNil(response)
        XCTAssertTrue(response.trips?.count ?? 0 > 0)
    }
}
