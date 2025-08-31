//
//  FlightServiceTests.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 10/06/2025.
//


import XCTest
@testable import SkyQuery

final class FlightServiceTests: XCTestCase {
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
    
    func testFlightServiceEndpoint() async throws {
        let mockClient = MockAPIClient()
        let service = FlightService(client: mockClient)
        let expectedResponse = try MockHelper.loadMockFromJSON(named: "FlightSearchResponse", responseType: FlightSearchResponse.self, for: FlightServiceTests.self)
        
        let parameters = FlightSearchParameters()
        mockClient.resultToReturn = expectedResponse
        
        let response = try await service.getFlights(with: parameters)
        
        let expectedParameters = [URLQueryItem(name: "flexdaysbeforeout", value: "3"),
                                  URLQueryItem(name: "flexdaysbeforein", value: "3"),
                                  URLQueryItem(name: "flexdaysin", value: "3"),
                                  URLQueryItem(name: "adt", value: "1"),
                                  URLQueryItem(name: "roundtrip", value: "false"),
                                  URLQueryItem(name: "ToUs", value: "AGREED")]
        
        XCTAssertTrue(mockClient.performRequestCalled)
        XCTAssertEqual(mockClient.endpointPassed?.path, "/api/v4/Availability")
        XCTAssertEqual(mockClient.endpointPassed?.host, "nativeapps.ryanair.com")
        XCTAssertEqual(mockClient.endpointPassed?.method.rawValue, "GET")
        XCTAssertEqual(mockClient.endpointPassed?.scheme, "https")
        XCTAssertEqual(mockClient.endpointPassed?.queryItems, expectedParameters)
        XCTAssertNotNil(mockClient.resultToReturn as? FlightSearchResponse)
        XCTAssertEqual(mockClient.resultToReturn as? FlightSearchResponse, response)
    }
    
    func testGetFlightsWithFail() async {
        let mockClient = MockAPIClient()
        let service = FlightService(client: mockClient)
        let parameters = FlightSearchParameters()
        
        mockClient.errorToThrow = URLError(.notConnectedToInternet)

        do {
            _ = try await service.getFlights(with: parameters)
            XCTFail("Expected error to be thrown, but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testGetSationWithFail() async {
        let mockClient = MockAPIClient()
        let service = FlightService(client: mockClient)
        
        mockClient.errorToThrow = URLError(.notConnectedToInternet)

        do {
            _ = try await service.getStations()
            XCTFail("Expected error to be thrown, but got success")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
    
    func testGetStationsSucess() async throws {
        let mockClient = MockAPIClient()
        let service = FlightService(client: mockClient)
        let expectedResponse = try MockHelper.loadMockFromJSON(named: "StationsResponse", responseType: StationResponse.self, for: FlightServiceTests.self)
        mockClient.resultToReturn = expectedResponse

        let response = try await service.getStations()
        let stations = mockClient.resultToReturn as? StationResponse
        
        XCTAssertTrue(mockClient.performRequestCalled)
        XCTAssertNotNil(expectedResponse)
        XCTAssertEqual(stations, response)
    }
    
    func testGetFlightsSucess() async throws {
        let mockClient = MockAPIClient()
        let service = FlightService(client: mockClient)
        let expectedResponse = try MockHelper.loadMockFromJSON(named: "FlightSearchResponse", responseType: FlightSearchResponse.self, for: FlightServiceTests.self)

        let response = try await service.getFlights(with: FlightSearchParameters())
        let flights = mockClient.resultToReturn as? FlightSearchResponse
        
        XCTAssertTrue(mockClient.performRequestCalled)
        XCTAssertNotNil(expectedResponse)
        XCTAssertEqual(flights, response)
    }
}
