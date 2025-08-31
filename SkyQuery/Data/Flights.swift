//
//  Flights.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 05/06/2025.
//


import UIKit

struct FlightSearchResponse: Codable {
    let currency: String?
    let serverTimeUTC: String?
    let currPrecision: Int?
    let trips: [Trip]?
}

extension FlightSearchResponse: Equatable {
    static func == (lhs: FlightSearchResponse, rhs: FlightSearchResponse) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.serverTimeUTC == rhs.serverTimeUTC &&
            lhs.currPrecision == rhs.currPrecision &&
            lhs.trips == rhs.trips
    }

}

struct Trip: Codable {
    let origin: String?
    let destination: String?
    let dates: [TripDate]?
}

extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.origin == rhs.origin &&
        lhs.destination == rhs.destination &&
        lhs.dates == rhs.dates
    }
}

struct TripDate: Codable {
    let dateOut: String?
    let flights: [Flight]?
}

extension TripDate: Equatable {
    static func == (lhs: TripDate, rhs: TripDate) -> Bool {
        return lhs.dateOut == rhs.dateOut &&
        lhs.flights == rhs.flights
    }
}

typealias Flights = [Flight]
struct Flight: Codable {
    let time: [String]?
    let timeUTC: [String]?
    let duration: String?
    let flightNumber: String?
    let faresLeft: Int?
    let flightKey: String?
    let infantsLeft: Int?
    let regularFare: FareDetails?
    let businessFare: FareDetails?
}

extension Flight: Equatable {
    static func == (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.time == rhs.time &&
        lhs.timeUTC == rhs.timeUTC &&
        lhs.duration == rhs.duration &&
        lhs.flightNumber == rhs.flightNumber &&
        lhs.faresLeft == rhs.faresLeft
    }
}

struct FareDetails: Codable {
    let fareKey: String?
    let fareClass: String?
    let fares: [Fare]?
}

extension FareDetails: Equatable {
    static func == (lhs: FareDetails, rhs: FareDetails) -> Bool {
        return lhs.fareKey == rhs.fareKey &&
        lhs.fareClass == rhs.fareClass &&
        lhs.fares == rhs.fares
    }
}

extension Fare: Equatable {
    static func == (lhs: Fare, rhs: Fare) -> Bool {
        return lhs.amount == rhs.amount &&
        lhs.count == rhs.count &&
        lhs.type == rhs.type &&
        lhs.hasDiscount == rhs.hasDiscount &&
        lhs.publishedFare == rhs.publishedFare
    }
}

struct Fare: Codable {
    let amount: Double?
    let count: Int?
    let type: String?
    let hasDiscount: Bool?
    let publishedFare: Double?
}
