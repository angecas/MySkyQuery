//
//  FlightSearchParameters.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 05/06/2025.
//

import UIKit

struct FlightSearchParameters {
    var origin: Station?
    var destination: Station?
    var dateOut: String?
    var dateIn: String?
    var flexDaysBeforeOut: Int? = 3
    var flexDaysOut: Int?
    var flexDaysBeforeIn: Int? = 3
    var flexDaysIn: Int? = 3
    var adults: Int? = 1
    var teens: Int?
    var children: Int?
    var roundTrip: Bool? = false
    var toUs: String? = "AGREED"
    var disc: Int?

    func toQueryItems() -> [URLQueryItem] {
        var items: [URLQueryItem] = []

        if let origin = origin, let originCode = origin.code {
            items.append(URLQueryItem(name: "origin", value: originCode))
        }

        if let destination = destination, let destinationCode = destination.code {
            items.append(URLQueryItem(name: "destination", value: destinationCode))
        }

        if let dateOut = dateOut {
            items.append(URLQueryItem(name: "dateout", value: dateOut))
        }

        if let dateIn = dateIn {
            items.append(URLQueryItem(name: "datein", value: dateIn))
        }

        if let flexDaysBeforeOut = flexDaysBeforeOut {
            items.append(URLQueryItem(name: "flexdaysbeforeout", value: "\(flexDaysBeforeOut)"))
        }

        if let flexDaysOut = flexDaysOut {
            items.append(URLQueryItem(name: "flexdaysout", value: "\(flexDaysOut)"))
        }

        if let flexDaysBeforeIn = flexDaysBeforeIn {
            items.append(URLQueryItem(name: "flexdaysbeforein", value: "\(flexDaysBeforeIn)"))
        }

        if let flexDaysIn = flexDaysIn {
            items.append(URLQueryItem(name: "flexdaysin", value: "\(flexDaysIn)"))
        }

        if let adults = adults {
            items.append(URLQueryItem(name: "adt", value: "\(adults)"))
        }

        if let teens = teens {
            items.append(URLQueryItem(name: "teen", value: "\(teens)"))
        }

        if let children = children {
            items.append(URLQueryItem(name: "chd", value: "\(children)"))
        }

        if let roundTrip = roundTrip {
            items.append(URLQueryItem(name: "roundtrip", value: roundTrip ? "true" : "false"))
        }

        if let toUs = toUs {
            items.append(URLQueryItem(name: "ToUs", value: toUs))
        }

        if let disc = disc {
            items.append(URLQueryItem(name: "Disc", value: "\(disc)"))
        }

        return items
    }
}

extension FlightSearchParameters {
    var hasParameters: Bool {
        return origin != nil  || destination != nil || dateOut != nil || adults ?? 1 > 1 || children ?? 0 > 0 || teens ?? 0 > 0
    }
}
