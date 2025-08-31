//
//  IncrementControl.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 08/06/2025.
//


import SwiftUI
struct IncrementControl: View {
    
    private enum Constants {
        static let imageWidth: CGFloat = 24
        static let horizontalSpacing: CGFloat = 8
        static let radius: CGFloat = 4
        static let fontSize: CGFloat = 16
        static let componentHeight: CGFloat = 52
    }

    @State var value: Int

    let minValue: Int
    let maxValue: Int
    let title: String
    let systemImage: String
    
    var onValueChange: (Int) -> Void
    
    init(value: Int, minValue: Int, maxValue: Int, title: String, systemImage: String, onValueChange: @escaping (Int) -> Void) {
        self._value = State(initialValue: value)
        self.minValue = minValue
        self.maxValue = maxValue
        self.title = title
        self.systemImage = systemImage
        self.onValueChange = onValueChange
    }
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.blue)
                .frame(width: Constants.imageWidth)
            
            Text(title)
                .font(.system(size: Constants.fontSize))
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                Button(action: {
                    if value > minValue {
                        value -= 1
                        onValueChange(value)
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(value > minValue ? .blue : .gray)
                }
                .disabled(value <= minValue)
                
                Text("\(value)")
                    .font(.system(size: Constants.fontSize))
                    .foregroundColor(.black)
                
                Button(action: {
                    if value < maxValue {
                        value += 1
                        onValueChange(value)
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(value < maxValue ? .blue : .gray)
                }
                .disabled(value >= maxValue)
            }
        }
        .padding(.horizontal, Constants.horizontalSpacing)
        .frame(height: Constants.componentHeight)
        .background(Color.white)
        .cornerRadius(Constants.radius)
    }
}
