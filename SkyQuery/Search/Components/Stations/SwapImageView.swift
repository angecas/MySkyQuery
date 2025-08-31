//
//  SwapImageView.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 09/06/2025.
//

import SwiftUI

import SwiftUI

struct SwapImageView: View {
    enum Constants {
        static let rotationDuration: Double = 0.25
        static let imageSize: CGSize = CGSize(width: 52, height: 52)
        static let rotationAngle: Double = 180
    }
    
    @State private var rotationAngle: Double = 0
    var onTap: (() -> Void)?
    
    var body: some View {
        Image(systemName: "arrow.up.and.down.circle")
            .resizable()
            .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
            .rotationEffect(Angle(degrees: rotationAngle))
            .onTapGesture {
                withAnimation(.easeInOut(duration: Constants.rotationDuration)) {
                    rotationAngle += Constants.rotationAngle
                }
                onTap?()
            }
    }
}
