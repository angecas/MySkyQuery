//
//  FlightCellView.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 08/06/2025.
//

import SwiftUI

struct FlightCellData {
    let trip: Trip?
    let currency: String?
}

struct FlightCellView: View {
    let trip: Trip?
    let currency: String?
    
    init(data: FlightCellData) {
        self.trip = data.trip
        self.currency = data.currency
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let trip = trip {

                Text("\(trip.origin ?? "") - \(trip.destination ?? "")")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)

                
                if let dates = trip.dates, !dates.isEmpty {
                    ForEach(dates, id: \.dateOut) { date in
                        VStack(alignment: .leading) {

                            if let dateOut = date.dateOut {
                                Text(dateOut.extractDay())
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            if let flights = date.flights, !flights.isEmpty {
                                ForEach(flights, id: \.flightNumber) { flight in
                                    FlightRowView(flight: flight)
                                }
                            } else {
                                Text(NSLocalizedString("no_flights_available", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                        }
                    }
                }
            } else {
                Text(NSLocalizedString("no_trip_info", comment: ""))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            }
        }
        .padding(.horizontal, 8)
        .background(Color(.appBlue))
    }
}


struct FlightRowView: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let flightNumber = flight.flightNumber {
                    Text("#\(flightNumber)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                if let duration = flight.duration {
                    Text("Duration: \(duration)")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            
            if let time = flight.time, let departTime = time.first, let arrivalTime = time.last {
                Text("\(departTime.extractTime() ) - \(arrivalTime.extractTime())")
                    .font(.caption)
                    .foregroundColor(.black)
            }
            
            if let faresLeft = flight.faresLeft {
                Text(String(format: NSLocalizedString("seats_left", comment: ""), faresLeft))
                    .font(.caption)
                    .foregroundColor(faresLeft < 10 ? .red : .black)
            }
        }
        .padding()
        .background(.white)
        .cornerRadius(4)
    }
}
