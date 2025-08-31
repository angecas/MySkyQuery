//
//  StationCellView.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 06/06/2025.
//

import SwiftUI

struct StationCellData {
    let station: Station?
    let isSelected: Bool
}

struct StationCellView: View {
    let station: Station?
    var isSelected: Bool

    init(data: StationCellData) {
        self.station = data.station
        self.isSelected = data.isSelected
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    if let name = station?.name {
                        Text(name)
                            .font(.subheadline)
                            .foregroundColor(.black)
                    }
                    
                    HStack(spacing: 4) {
                        if let country = station?.countryName {
                            Text(country)
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        
                        if let code = station?.code {
                            Text("· \(code)")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "dot.scope")
                        .foregroundColor(.blue)
                }
            }
            Divider()
        }
        .padding(.all, 8)
        .background(.white)
    }
}

