//
//  ContentView.swift
//  RubberBandToggle
//
//  Created by OrdinaryIndustries on 5/7/23.
//

import SwiftUI


struct CustomToggleStyle: ToggleStyle {
    @State private var offset = CGSize.zero
    
    // Add some stickiness to the circle.
    let dragDamping: Double = 0.4
    
    // How far off the toggle the circle needs to be pulled before it snaps to the touch point.
    let stickiness: CGFloat = 80.0

    // The SF symbol to use for the toggle's on state.
    var onImage: String = "checkmark.circle"
    // The SF symbol to use for the toggle's on state.
    var offImage: String = "xmark.circle"
    
    // The on state background color.
    var onColor: Color = Color("ToggleOn")
    // The off state background color.
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
                    // The on and off points for the circle. When the toggle is tapped, the circle will be moved between these two points.
                    .offset(x: configuration.isOn ? 50 : -50)
                    
                    // Make the circle moveable.
                    .offset(x: offset.width, y: offset.height)
                    .gesture(
                        DragGesture()
                            // Setup dragging the circle. If the circle is within the stickiness distance from where it started then the drag distance is manipulated to be exponentially shorter. This adds a feeling like the circle doesn't want to leave the toggle. If the circle gets past the stickeness distance then it snaps to the gesture's current position. Visually this means the circle jump to the user's finger.
                            .onChanged { gesture in
                                if abs(offset.height) > stickiness || abs(offset.width) > stickiness {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                                        offset.width = gesture.translation.width
                                        offset.height = gesture.translation.height
                                    }
                                } else {
                                    offset.width = gesture.translation.width * dragDamping
                                    offset.height = gesture.translation.height * dragDamping
                                }
                            }
                            // When the user lifts their finger snap the circle back to the toggle with some springiness. This also toggles the toggle state.
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
