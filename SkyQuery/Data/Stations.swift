//
//  Stations.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 05/06/2025.
//

import UIKit

struct StationResponse: Codable {
    let stations: [Station]
}

extension StationResponse: Equatable {
    public static func == (lhs: StationResponse, rhs: StationResponse) -> Bool {
        return lhs.stations == rhs.stations
    }
}

typealias Stations = [Station]
struct Station: Codable {
    let alias: [String]?
    let alternateName: String?
    let code: String?
    let countryAlias: String?
    let countryCode: String?
    let countryGroupCode: String?
    let countryGroupName: String?
    let countryName: String?
    let latitude: String?
    let longitude: String?
    let markets: [Market]?
    let mobileBoardingPass: Bool?
    let name: String?
    let notices: String?
    let timeZoneCode: String?
}

extension Station: Equatable {
    static func == (lhs: Station, rhs: Station) -> Bool {
        return lhs.code == rhs.code
    }

    var stationString: String? {
        guard let name = name, let code = code else { return nil }
        return "\(name) - \(code)"
    }
}

struct Market: Codable {
    let code: String?
    let group: String?
    let stops: [Stop]?
    let onlyConnecting: Bool?
}

struct Stop: Codable {
    let code: String?
}

