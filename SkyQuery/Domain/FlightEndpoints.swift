//
//  APIEndpoint.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import Foundation

// MARK: - Protocols

// MARK: - Endpoint Definitions
enum StationsEndpoint: APIEndpoint {
    case getStations
    
    var scheme: String { "https" }
    var host: String { "mainHost" } //TODO: update with new endpoint
    var path: String { "/stations.json" }
    var method: HTTPMethod { .get }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "client": "ios",
            "client-version": "3.999.0"
        ]
    }
    
    var queryItems: [URLQueryItem]? { nil }
}

enum FlightsEndpoint: APIEndpoint {
    case searchFlights(FlightSearchParameters)
    
    var scheme: String { "https" }
    var host: String { "mainHost" } //TODO: update with new endpoint
    var path: String { "/api/v4/Availability" }
    var method: HTTPMethod { .get }
    
    var headers: [String: String] {
        return [
            "Content-Type": "application/json",
            "client": "ios",
            "client-version": "3.999.0"
        ]
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchFlights(let parameters):
            return parameters.toQueryItems()
        }
    }
}
