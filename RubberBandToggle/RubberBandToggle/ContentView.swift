//
//  ContentView.swift
//  RubberBandToggle
//
//  Created by OrdinaryIndustries on 5/7/23.
//

import SwiftUI


struct CustomToggleStyle: ToggleStyle {
    @State private var offset = CGSize.zero
    
    let dragDamping: Double = 0.4
    let offsetThreshold: CGFloat = 100.0

    var onImage: String = "checkmark"
    var offImage: String = "checkmark"
    var onColor: Color = Color("ToggleOn")
    var offColor: Color = Color("ToggleOff")

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 60)
                .fill(configuration.isOn ? onColor : offColor)
                .overlay {
                    ZStack {
                        Circle()
                            .foregroundColor(.black)
                            .padding(10)
                        Image(systemName: configuration.isOn ? onImage : offImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .padding(30)
                            .rotationEffect(.degrees(configuration.isOn ? 0 : -360))
                            .foregroundColor(.white)
                    }
                    .offset(x: configuration.isOn ? 50 : -50)
                    .offset(x: offset.width, y: offset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                if abs(offset.height) > offsetThreshold || abs(offset.width) > offsetThreshold {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.4)) {
                                        offset.width = gesture.translation.width
                                        offset.height = gesture.translation.height
                                    }
                                } else {
                                    offset.width = gesture.translation.width * dragDamping
                                    offset.height = gesture.translation.height * dragDamping
                                }
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                    offset = .zero
                                }
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                                    configuration.isOn.toggle()
                                }
                            }
                    )
                }

                .frame(width: 200, height: 100)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}

struct ContentView: View {
    @State private var toggleIsOn: Bool = false
    
    var body: some View {
        VStack {
            Toggle("", isOn: $toggleIsOn)
                .toggleStyle(CustomToggleStyle(onImage: "sun.max.fill", offImage: "moon.fill", onColor: Color(.systemGray6), offColor: Color(.systemGray2)))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
